<script lang="ts">
	import { pageTitle, pageSubtitle } from '$lib/store.js';
    import Navbar from '$lib/components/Navbar/Navbar.svelte';
    import Sidebar from "$components/sidebars/HighlightsSidebar.svelte";
    import {PageTitle, ThreeColumnsLayout} from "@kind0/ui-common";
    import HighlightList from '$lib/components/HighlightList.svelte';
    import { page } from "$app/stores";
    import { onDestroy } from 'svelte';
    import { NDKKind, NDKHighlight } from "@nostr-dev-kit/ndk";
    import RightSidebar from './components/RightSidebar/RightSidebar.svelte';
    import ModeTab from './components/ModeTab.svelte';
    import { ndk } from "@kind0/ui-common";
    import type { NDKEventStore } from '@nostr-dev-kit/ndk-svelte';

    let topic: string
    let prevTopic: string
    let highlights: NDKEventStore<NDKHighlight> | undefined;
    /**
     * The npubs who have created highlights in this topic
     */
    let users: Set<string> = new Set();

    /**
     * Other topics highlighted in this topic
     */
    let otherTopics: Set<string> = new Set();
    let topicCounts: Map<string, number> = new Map();

    $: topic = $page.params.topic;

    $: {
        $pageTitle = `#${topic}`;
    }

    onDestroy(() => {
        $pageTitle = null;
        $pageSubtitle = null;

        if (highlights) highlights.unsubscribe();
    })

    $: if (topic && topic !== prevTopic) {
        prevTopic = topic;
        users.clear();
        otherTopics.clear();
        if (highlights) highlights.unsubscribe();

        highlights = $ndk.storeSubscribe([
            { kinds: [NDKKind.Highlight as number], '#t': [topic], limit: 20 },
            { kinds: [NDKKind.Highlight as number], '#l': [topic], limit: 20 },
        ],
            {
                repostsFilters: [
                    { kinds: [16 as number], '#k': [NDKKind.Highlight.toString()], '#t': [topic], limit: 10 },
                ],
                closeOnEose: false,
            },
            NDKHighlight
        );
    }

    $: $highlights?.forEach((highlight: NDKHighlight) => {
        users.add(highlight.author.npub);
        const topicTags = highlight.getMatchingTags('t');
        topicTags.forEach((tag) => {
            if (tag[1] !== topic) {
                otherTopics.add(tag[1]);
                topicCounts.set(tag[1], (topicCounts.get(tag[1]) || 0) + 1);
            }
        });
        users = users;
        otherTopics = otherTopics;
    });

    // Sorted list of other topics with counts
    let sortedOtherTopics: { topic: string; count: number }[] = [];

    $: {
        sortedOtherTopics = Array.from(otherTopics).map((topic) => ({
            topic,
            count: topicCounts.get(topic) || 0,
        })).sort((a, b) => b.count - a.count);
    }

</script>

<ThreeColumnsLayout>
    <div slot="navbar">
        <Navbar />
    </div>

    <div slot="sidebar">
        <Sidebar />
    </div>

    {#if $pageTitle}
        <PageTitle title={$pageTitle} subtitle={$pageSubtitle}>
            <div class="flex flex-col items-end justify-between h-full">
                <ModeTab />

                <div class="flex-grow"></div>
            </div>
        </PageTitle>
    {/if}

    {#if $highlights}
        <HighlightList items={$highlights} />
    {/if}

    <div slot="rightSidebar" class="flex flex-col gap-4">
        <RightSidebar {users} {otherTopics} {sortedOtherTopics} />
    </div>
</ThreeColumnsLayout>
