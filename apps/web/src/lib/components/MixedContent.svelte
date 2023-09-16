<script lang="ts">
    import { PageTitle, ndk } from "@kind0/ui-common";
    import ModeTab from "../../routes/t/[naddr]/components/ModeTab.svelte";
    import HighlightList from "$components/HighlightList.svelte";
    import { MarginNoteCard } from "@highlighter/svelte-kit-lib";
    import { type NDKEvent, NDKArticle, NDKHighlight, type NDKFilter, NDKKind } from "@nostr-dev-kit/ndk";
    import type { NDKEventStore } from "@nostr-dev-kit/ndk-svelte";
    import type { Readable } from "svelte/motion";
    import { derived } from "svelte/store";
    import { onDestroy } from "svelte";

    export let title: string;
    export let topics: string[];
    export let authors: string[] | undefined = undefined;

    let subscription: NDKEventStore<NDKEvent>;
    let articles: Readable<NDKArticle[]>;
    let highlights: Readable<NDKHighlight[]>;
    let notes: Readable<NDKEvent[]>;

    let articlesExpanded = false;

    const filters: NDKFilter[] = [];
    const repostsFilters: NDKFilter[] = [];

    if (topics.length > 0) {
        filters.push(
            { kinds: [NDKKind.Highlight, NDKKind.Article], "#t": topics },
            { kinds: [1], "#k": ["9802"], "#t": topics },
        );

        repostsFilters.push(
            { kinds: [NDKKind.Label], "#l": topics },
            { kinds: [NDKKind.GenericRepost], "#t": topics },
        )
    }

    if (authors && authors.length > 0) {
        filters.push(
            { kinds: [NDKKind.Highlight, NDKKind.Article], authors }
        )

        repostsFilters.push(
            { kinds: [NDKKind.GenericRepost], "#k": ["9802"] },
        )
    }

    subscription = $ndk.storeSubscribe(
        filters,
        {
            repostsFilters,
            groupable: false,
            autoStart: true,
            subId: "topic-filter",
            closeOnEose: true
        }
    )

    articles = derived(subscription, $subscription => {
        const ids = new Set<string>();

        return $subscription.filter(event => event.kind === NDKKind.Article)
            .map(event => NDKArticle.from(event))
            .filter(article => {
                if (ids.has(article.id)) return false;
                return ids.add(article.id);
            });
    })

    highlights = derived(subscription, $subscription => {
        const ids = new Set<string>();

        return $subscription.filter(event => event.kind === NDKKind.Highlight)
            .map(event => NDKHighlight.from(event))
            .filter(article => {
                if (ids.has(article.id)) return false;
                return ids.add(article.id);
            });
    })

    notes = derived(subscription, $subscription => {
        const ids = new Set<string>();

        return $subscription.filter(event => event.kind === 1)
            .map(event => NDKHighlight.from(event))
            .filter(article => {
                if (ids.has(article.id)) return false;
                return ids.add(article.id);
            });
    })
</script>

<PageTitle {title}>
    <div class="flex flex-col items-end justify-between h-full">
        <ModeTab />

        <div class="flex-grow"></div>
    </div>
</PageTitle>

<!-- {#if $articles.length > 0}
    <Section
        title="Articles"
        on:click={() => { articlesExpanded = true; }}
        expanded={articlesExpanded}
    >
        {#each $articles as article (article.id)}
            <div class="flex items-center justify-center">
                <ArticleContentCard {article} />
            </div>
        {/each}
    </Section>
{/if} -->

{#if $notes.length > 0}
    <div class="flex flex-col gap-4 w-full">
        {#each $notes as note (note.id)}
            <MarginNoteCard event={note} />
        {/each}
    </div>
{/if}

{#if $highlights.length > 0}
    <HighlightList
        items={$highlights}
    />
{/if}