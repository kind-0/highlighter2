<script lang="ts">
    import TagContentCards from "$components/ContentCards/TagContentCards.svelte";
    import Section from "$components/Section.svelte";
    import { highlights, loadingScreen } from "$stores/session";
    import type { NDKTag } from "@nostr-dev-kit/ndk";
    import { slide } from "svelte/transition";
    import { debounce } from "throttle-debounce";

    let expanded = false;
    export let articlesToRender = 20;

    let renderedArticles: Map<string, NDKTag> = new Map();

    const selectArticles = debounce(50, (count: number) => {
        const highlightedArticles = new Set<NDKTag>();
        const sortedHighlights = Array.from($highlights.values())
            .sort((a, b) => b.created_at - a.created_at)
            .slice(0, count * 3);

        for (const highlight of sortedHighlights) {
            const articleTag = highlight.getArticleTag();
            if (articleTag) {
                highlightedArticles.add(articleTag);
            }
        }

        renderedArticles = new Map();
        for (const articleTag of Array.from(highlightedArticles)) {
            renderedArticles.set(articleTag[1], articleTag);
        }
    })

    $: if ($highlights) selectArticles(articlesToRender);

    let highlightsWithArticleTags: number;

    $: highlightsWithArticleTags = $highlights && Array.from($highlights.values()).filter(h => !!h.getArticleTag()).length;

    let loadedCards = 0;

    function loadedCard() {

        if (++loadedCards > 4 && $loadingScreen) {
            $loadingScreen = false;
        }

        console.log(`loaded card ${loadedCards}`);
    }
</script>

<div transition:slide={{ axis: 'y'}}>
    <Section
        title={`Recently Highlighted`}
        on:click={() => { expanded = true; }}
        {expanded}
    >
        <TagContentCards
            tags={Array.from(renderedArticles.values())}
            on:loaded={loadedCard}
        />
    </Section>
</div>
