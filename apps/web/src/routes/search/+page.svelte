<script lang="ts">
    import { page } from '$app/stores';
    import Section from '$components/Section.svelte';
    import HighlightList from '$components/HighlightList.svelte';
    import { EntryInput, ndk } from "@kind0/ui-common";
    import {  PageTitle } from '@kind0/ui-common';
    import { NDKRelaySet, NDKHighlight, NDKArticle, type NDKTag } from '@nostr-dev-kit/ndk';
    import type { NDKEventStore } from '@nostr-dev-kit/ndk-svelte';
    import TagContentCards from '$components/ContentCards/TagContentCards.svelte';
    import { derived, type Readable } from 'svelte/store';
    import ArticleContentCard from '$components/ContentCards/ArticleContentCard.svelte';
    import PageContainer from '$components/PageContainer.svelte';
    import { goto } from '$app/navigation';
    import { rxp_uri } from '$utils/rxp';
    import SearchPageLinkButton from '$components/buttons/SearchPageLinkButton.svelte';
    let query: string | null;
    let prevQuery: string;

    let highlights: NDKEventStore<NDKHighlight>;
    let articles: NDKEventStore<NDKArticle>;
    const relaySet = NDKRelaySet.fromRelayUrls([
        'wss://relay.noswhere.com',
        'wss://relay.nostr.band/'
    ], $ndk);

    $: query = $page.url.searchParams.get('q');

    $: if (query && query !== prevQuery) {
        prevQuery = query;

        if (highlights) {
            highlights.unsubscribe();
            users.clear();
            otherTopics.clear();
            topicCounts.clear();
        }
        if (articles) articles.unsubscribe();

        highlights = $ndk.storeSubscribe({
            "search": query,
            kinds: [9802],
        }, { groupable: false, relaySet, subId: 'highlight-search' },
            NDKHighlight);

        articles = $ndk.storeSubscribe({
            "search": query,
            kinds: [30023],
            limit: 50,
        }, { groupable: false, relaySet, subId: 'articles-search' },
            NDKArticle);

        highlightedArticles = derived(highlights, $highlights => {
            const items = new Map<string, NDKTag>();

            for (const h of $highlights) {
                users.add(h.author.npub);
                const tag = h.getArticleTag();
                const topicTags = h.getMatchingTags('t');
                topicTags.forEach((tag) => {
                    otherTopics.add(tag[1]);
                    topicCounts.set(tag[1], (topicCounts.get(tag[1]) || 0) + 1);
                });
                if (tag) items.set(tag[1], tag);
            }

            users = users;
            otherTopics = otherTopics;

            return Array.from(items.values());
        })
    }

    // Sorted list of other topics with counts
    let sortedOtherTopics: { topic: string; count: number }[] = [];

    $: {
        sortedOtherTopics = Array.from(otherTopics).map((topic) => ({
            topic,
            count: topicCounts.get(topic) || 0,
        })).sort((a, b) => b.count - a.count);
    }

    let expanded = false;
    let highlightedArticles: Readable<NDKTag[]>;

    /**
     * The npubs who have created highlights in this topic
     */
    let users: Set<string> = new Set();
    let otherTopics: Set<string> = new Set();
    let topicCounts: Map<string, number> = new Map();

    let searchQueryText = ``
    let _errorMsg = ``

    async function search_submit() {
        if(!!searchQueryText) {
            await goto(`/search?q=${searchQueryText}`)
        } else {
            _errorMsg = `Enter a search parameter.`
        }
        return;
    }
</script>

<svelte:head>
    <title>{query} search on Highlighter</title>
</svelte:head>

<PageContainer>
    {#if query}
        <PageTitle title="Search:" subtitle={`"${query}"`} class="" />

        <div class="flex flex-row w-full justify-end items-center p-4">
            <SearchPageLinkButton />
        </div>

        <div class="flex flex-col w-full divide-y-2 divide-base-300 gap-4">
            {#key query}
                {#if $highlightedArticles.length > 0}
                    <Section
                        title="Highlighted Articles"
                        on:click={() => { expanded = true; }}
                        {expanded}
                    >
                        <TagContentCards tags={$highlightedArticles} />
                    </Section>
                {/if}
            {/key}

            {#if $articles.length > 0}
                <Section
                    title="Articles"
                    on:click={() => { expanded = true; }}
                    {expanded}
                >
                    {#each $articles as article}
                        <ArticleContentCard {article} />
                    {/each}
                </Section>
            {:else}
                <div class="flex flex-col w-full justify-center items-center gap-4 pt-4">
                    <p class="font-sans font-medium text-base">
                        {`No articles have been found.`}
                    </p>
                    <SearchPageLinkButton>{`go to search`}</SearchPageLinkButton>
                </div>
            {/if}

            {#if $highlights && $highlights.length > 0}
                <Section
                    title="Highlights"
                    expanded={true}
                    flow="column"
                >
                    <HighlightList items={$highlights} />
                </Section>
            {/if}
        </div>
        <!-- @note-pablo, removed this
        <div slot="rightSidebar" class="flex flex-col gap-4">
            <RelatedUsersAndTopics {users} {otherTopics} {sortedOtherTopics} />
        </div> -->
    {:else}
        <div class="flex flex-col w-full justify-start items-center gap-2 px-4">
            <div class="flex flex-row w-full justify-start items-center">
                <p class="font-sans font-bold text-4xl">
                    {`Search`}
                </p>
            </div>
            <div class="flex flex-row w-full justify-center items-center">
                <EntryInput 
                    class="w-full rounded-full" 
                    placeholder={`Search`} 
                    onInputCallback={async _ => { _errorMsg = `` }}
                    onInputValidation={async v => rxp_uri.test(v)}
                    onInputValidationSuccess={async v => { searchQueryText = v }} 
                    />
            </div>
            {#if !!_errorMsg}
                <div class="flex flex-row w-full justify-center items-center">
                    <p class="font-sans font-medium text-base">
                        {_errorMsg}
                    </p>
                </div>
            {/if}
            <div class="flex flex-row w-full justify-center items-center px-4 pt-4">
                <button class="btn btn-sm btn-neutral btn-wide" on:click={search_submit}>
                    Submit
                </button>
            </div>
        </div>
    {/if}
</PageContainer>

