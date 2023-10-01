<script lang="ts">
    import { page } from '$app/stores';
    import Section from '$components/Section.svelte';
    import HighlightList from '$components/HighlightList.svelte';
    import { ndk } from "@kind0/ui-common";
    import { ThreeColumnsLayout, PageTitle } from '@kind0/ui-common';
    import { NDKRelaySet, NDKHighlight, NDKArticle, type NDKTag } from '@nostr-dev-kit/ndk';
    import type { NDKEventStore } from '@nostr-dev-kit/ndk-svelte';
    import TagContentCards from '$components/ContentCards/TagContentCards.svelte';
    import { derived, type Readable } from 'svelte/store';
    import Navbar from '$components/Navbar/Navbar.svelte';
    import HighlightsSidebar from '$components/sidebars/HighlightsSidebar.svelte';
    import ArticleContentCard from '$components/ContentCards/ArticleContentCard.svelte';
    import RelatedUsersAndTopics from '../web/components/RightSidebar/RelatedUsersAndTopics.svelte';
    import PageContainer from '$components/PageContainer.svelte';
    import { onMount } from 'svelte';
    import { goto } from '$app/navigation';
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

    let searchText = ``

    async function submit() {
        await goto(`/search?q=${searchText}`)
        return;
    }
</script>

<svelte:head>
    <title>{query} search on Highlighter</title>
</svelte:head>

<PageContainer>
    {#if query}
        <PageTitle title="Search" subtitle={`"${query}"`} class="mb-8" />

        <div class="flex flex-col divide-y-2 divide-base-300 gap-4">
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

        <!-- @note-pablo,removed  <div slot="rightSidebar" class="flex flex-col gap-4">
            <RelatedUsersAndTopics {users} {otherTopics} {sortedOtherTopics} />
        </div> -->
    {:else}
        <div class="flex flex-col w-full justify-center items-center">
            <div class="flex flex-row w-full justify-center items-center">
                <input class="input w-full" on:input={({currentTarget:{value}}) => searchText = value} />
            </div>
            <div class="flex flex-row w-full justify-end items-center">
                <button class="btn" on:click={submit}>
                    Search
                </button>
            </div>
        </div>
    {/if}
</PageContainer>

