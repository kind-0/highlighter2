<script lang="ts">
    import TagContentCard from "$components/ContentCards/TagContentCard.svelte";
import Section from "$components/Section.svelte";
    import { highlights } from "$stores/session";
    import type { NDKTag } from "@nostr-dev-kit/ndk";
    import { slide } from "svelte/transition";
    import { debounce } from "throttle-debounce";

    let expanded = false;
    export let articlesToRender = 50;

    let renderedArticles: Map<string, NDKTag> = new Map();

    const selectArticles = debounce(300, (count: number) => {
        const highlightsPerArticle = new Map<NDKTag, number>();

        for (const highlight of $highlights.values()) {
            const articleTag = highlight.getArticleTag();
            if (articleTag) {
                if (highlightsPerArticle.has(articleTag)) {
                    highlightsPerArticle.set(articleTag, highlightsPerArticle.get(articleTag)! + 1);
                } else {
                    highlightsPerArticle.set(articleTag, 1);
                }
            }
        }

        const mostHighlightedArticles = Array.from(highlightsPerArticle.entries()).sort((a, b) => a[1] - b[1]).slice(0, count);

        console.log(mostHighlightedArticles);

        renderedArticles = new Map();
        for (const [articleTag, _] of mostHighlightedArticles) {
            renderedArticles.set(articleTag[1], articleTag);
        }
    })

    $: console.log(renderedArticles);

    $: if ($highlights) selectArticles(articlesToRender);
</script>

<div transition:slide={{ axis: 'y'}}>
    <Section
        title="Recently Highlighted"
        on:click={() => { expanded = true; }}
        {expanded}
    >
        {#each Array.from(renderedArticles.values()) as article}
            <TagContentCard tag={article} />
        {/each}
    </Section>
</div>
