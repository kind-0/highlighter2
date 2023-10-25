<script lang="ts">
    import { NDKEvent, NDKKind, type NDKFilter, type Hexpubkey, type NDKEventId } from '@nostr-dev-kit/ndk';
    import { ndk } from "@kind0/ui-common";
    import { currentScope } from '$lib/store';
    import { derived, writable, type Readable } from 'svelte/store';
    import HighlightWrapper from '../HighlightWrapper.svelte';
    import Article from '../Article.svelte';
    import { NDKArticle } from "@nostr-dev-kit/ndk";
    import { onDestroy } from 'svelte';
    import { NDKHighlight } from "@nostr-dev-kit/ndk";
    import MarkedContent from './MarkedContent.svelte';
    import NewHighlight from "$components/highlights/NewHighlight.svelte";
    import { AvatarWithName } from "@kind0/ui-common";
    import RightDrawerLayout from '$lib/layouts/RightDrawerLayout.svelte';
    import type { NDKEventStore } from '@nostr-dev-kit/ndk-svelte';
    import { user } from '$stores/session';
    import { CaretLeft } from 'phosphor-svelte';
    import AddToShelfButton from '$components/buttons/AddToShelfButton.svelte';
    import ArticleWideCard from './ArticleWideCard.svelte';
    import { ReaderMarginNotePopup } from '@highlighter/svelte-kit-lib';
    import { rightDrawerContent } from '$stores/right-drawer';
    import { fade } from 'svelte/transition';

    export let article: NDKEvent | NDKArticle | string;
    export let content: string | undefined = undefined;
    export let unmarkedContent: string;
    export let url: string | undefined = undefined;
    export let renderAsHtml: boolean = false;

    let scope: string;

    let needsFilterUpdate: boolean;

    let articleEvents: NDKEventStore<NDKEvent> | undefined;
    let highlights: Readable<NDKHighlight[]>;
    let marginNotes: Readable<NDKEvent[]>;
    let usersWithInteractions: Readable<Hexpubkey[]>;

    // Set filter for current view
    $: if (scope !== $currentScope.label) {
        scope = $currentScope.label;
        let pubkeys: string[] | undefined | null = null;

        needsFilterUpdate = true;
    }

    // Apply filter when it's ready
    $: if (needsFilterUpdate) {
        needsFilterUpdate = false;

        if (articleEvents) {
            articleEvents.unsubscribe();
        }

        let articleFilter: NDKFilter;

        if (article instanceof NDKEvent) {
            articleFilter = article.filter();
        } else {
            articleFilter = { "#r": [article.url ?? article] };
        }

        articleEvents = $ndk.storeSubscribe(
            { ...articleFilter },
            { closeOnEose: false, groupableDelay: 50 }
        );

        highlights = derived(articleEvents, ($articleEvents) => {
            const highlights = new Set<NDKHighlight>();

            $articleEvents.forEach(event => {
                if (event.kind === NDKKind.Highlight) {
                    highlights.add(NDKHighlight.from(event));
                }
            });

            return Array.from(highlights).slice(0, 20);
        });

        marginNotes = derived(articleEvents, ($articleEvents) => {
            const marginNotes = new Set<NDKEvent>();

            $articleEvents.forEach(event => {
                if (event.kind === 1 && event.tagValue("k")) {
                    marginNotes.add(event);
                }
            });

            return Array.from(marginNotes);
        });

        usersWithInteractions = derived(articleEvents, ($articleEvents) => {
            const users = new Set<Hexpubkey>();

            $articleEvents.forEach(event => {
                if (
                    (event.kind === 9802 || event.kind === 1) &&
                    event.pubkey !== article?.pubkey)
                    users.add(event.pubkey);
            });

            return Array.from(users);
        });

        // deduppedHighlights = derived(highlights, ($highlights) => {
        //     const uniqueItems: NDKHighlight[] = [];
        //     const seenContent = new Set();

        //     $highlights.forEach(item => {
        //         let content = item.content.trim()+item.pubkey;
        //         if (!seenContent.has(content)) {
        //             seenContent.add(content);
        //             uniqueItems.push(item);
        //         }
        //     });

        //     return uniqueItems;
        // });
    }

    onDestroy(() => {
        articleEvents?.unsubscribe();
    });

    let newHighlightItem: NDKHighlight | undefined;
    let openedHighlight: NDKHighlight | undefined;

    /**
     * Choose the context for the highlight
     */
    function chooseContext(selection: string, sentence: string, paragraph: string): string {
        let context = sentence;

        // If the selection is 3x shorter than the paragraph, use the sentence
        if (
            selection.length > 30 && // wait until there is enough text selected to make this call, otherwise the UX is weird
            selection.length * 20 < paragraph.length) {
            context = sentence;
        }

        // if (selection.length >= paragraph.length) {
        //     context = undefined;
        // }

        return context;
    }

    function onSelectionChange(e: Event) {
        let {selection, sentence, paragraph } = e.detail;
        let context: string | undefined;

        selection = selection.trim();
        paragraph = paragraph.trim();
        sentence = sentence.trim();

        context = chooseContext(selection, sentence, paragraph);

        if (selection.trim() === '') return;

        if (selection) {
            if (!newHighlightItem) {
                newHighlightItem = new NDKHighlight($ndk);
                newHighlightItem.author = $user!;

                if (article.id) {
                    newHighlightItem.article = article!;
                } else if (article.url) {
                    newHighlightItem.article = article.url;
                }
            }

            newHighlightItem.content = selection;
            newHighlightItem.context = context;
        } else {
            newHighlightItem = undefined;
        }
    }

    function onNewHighlightClose() {
        newHighlightItem = undefined;
        openedHighlight = undefined;
    }

    function articleTitle() {
        if (article.title) return article.title;

        if (article instanceof NDKEvent) {
            return article.content.slice(0, 20) + "...";
        }

        return article?.title || article?.url || article.toString();
    }

    let articleTopicsId: string;
    let topics: string[] = [];

    $: if (article?.id && articleTopicsId !== article.id) {
        articleTopicsId = article.id;
        const articleTopics = (article.tags??[]).filter(t => t[0] === 't').map(t => t[1]).slice(0,10);
        topics = articleTopics || [];
    }

    function highlightClicked(e: Event) {
        const highlight = e.detail;
        openedHighlight = highlight;
        topics = [];
    }

    // TODO: Use this popup position to mark to users
    // when there are highlights outside the viewport
    // (e.g. 10 highlights below)
    const popupPosition: Record<NDKEventId, number> = {}

    const popupPositions = writable(new Set<number>());
</script>

<svelte:head>
    <title>{articleTitle() || "Highlighter.com"}</title>
</svelte:head>

<RightDrawerLayout>
    <div class="
        flex flex-col xl:flex-row mx-auto xl:px-6 xl:pt-4
    ">
        <!-- article container -->
        <div class="
            flex flex-col
            md:w-7/12
        ">
            <div class="flex flex-col w-full">
                <div class="
                    sticky xl:!rounded-t-xl top-0 p-4 border-b-2 border-base-300 bg-base-200/80 left-0 right-0
                    flex flex-row items-center justify-between
                ">
                    <div class="flex flex-row gap-4 items-center w-1/4">
                        <a href="/reader" class="btn !rounded-full">
                            <CaretLeft />
                            Back
                        </a>
                    </div>

                    <div class="max-sm:hidden text-base-100-content font-semibold w-2/4 text-lg flex-grow text-center whitespace-nowrap truncate">
                        {articleTitle()}
                    </div>

                    <div class="flex flex-row gap-4 items-center w-1/4 justify-end">
                        <AddToShelfButton
                            event={article}
                            class="btn !rounded-full"
                        />
                    </div>
                </div>
            </div>
            {#if article instanceof NDKArticle}
                <ArticleWideCard
                    {article}
                    highlightCount={$highlights.length}
                    usersWithInteractions={$usersWithInteractions}
                    class="rounded-none min-h-[12rem] p-4 bg-base-200"
                />
            {/if}
            <div class="rounded-t-none border-t-2 border-base-300 join-item card leading-loose flex flex-col gap-2 text-lg card-compact xl:card-normal">
                <div class="card-body">
                    {#if !(article instanceof NDKArticle)}
                        <!-- Title -->
                        {#if articleTitle()}
                            <h1 class="card-title flex flex-row justify-center text-2xl xl:text-3xl font-bold xl:text-center leading-normal">{articleTitle()}</h1>
                        {/if}

                        <div class="flex flex-row justify-between mb-2 overflow-clip items-center">
                            <!-- Author / URL -->
                            {#if article?.author && article?.author?.hexpubkey}
                                <AvatarWithName
                                    pubkey={article.author.hexpubkey}
                                    avatarClass="w-12 h-12 rounded-full"
                                    nameClass="text-xl font-semibold"
                                />
                            {:else if url}
                                <div class="text-xs whitespace-normal">
                                    {url}
                                </div>
                            {:else}
                                <div></div>
                            {/if}
                        </div>
                    {/if}

                    {#if $$slots.preArticle}
                        <slot name="preArticle" />
                    {/if}

                    <!-- Content -->
                    <HighlightWrapper on:selectionchange={onSelectionChange}>
                        <article class="my-2">
                            <Article class="highlighter">
                                {#if $$slots.default}
                                    <slot />
                                {:else}
                                    <MarkedContent
                                        {renderAsHtml}
                                        content={content??""}
                                        {unmarkedContent}
                                        {highlights}
                                        tags={article.tags}
                                        addNewLines={true}
                                        on:highlight-clicked={highlightClicked}
                                    />
                                {/if}
                            </Article>
                        </article>
                    </HighlightWrapper>
                </div>
            </div>
        </div>

        <!-- Sidebar  -->
        <div class="
        " id="sidebarContainer">
            <div class="h-auto xl:h-screen">
                {#if newHighlightItem}
                    <div class="z-50 fixed top-20 flex pt-8 px-4" transition:fade>
                        <NewHighlight
                            highlight={newHighlightItem}
                            title={article?.url ? article.title : undefined}
                            on:close={onNewHighlightClose}
                            bind:topics
                        />
                    </div>
                {/if}

                {#if openedHighlight}
                    <div class="z-50 fixed top-20 px-4" transition:fade>
                        <NewHighlight
                            highlight={openedHighlight}
                            on:close={onNewHighlightClose}
                            bind:topics
                        />
                    </div>
                {/if}

                <div class="
                    {(newHighlightItem || openedHighlight) ? 'opacity-50' : ''}
                    transition duration-100
                    xl:mb-96 px-4
                ">
                    {#if article}
                        <div class="flex flex-col gap-4">
                            {#each $highlights as highlight (highlight.id)}
                                <ReaderMarginNotePopup
                                    highlightEvent={highlight}
                                    user={highlight.author}
                                    {marginNotes}
                                    class={!!$rightDrawerContent ? "hidden" : ""}
                                    bind:verticalPosition={popupPosition[highlight.id]}
                                    {popupPositions}
                                />
                            {/each}
                        </div>
                    {/if}
                </div>
            </div>
        </div>
    </div>
</RightDrawerLayout>

<!-- This classes are here so they don't get tree-shaken from the ui-common package -->
<div class="
    hidden lg:card-side lg:items-center lg:flex-row lg:gap-4 py-10 lg:!w-48 !min-h-96 lg:!w-[100px]
"></div>