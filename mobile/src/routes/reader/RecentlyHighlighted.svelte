<script lang="ts">
    import TagContentCards from "$components/ContentCards/TagContentCards.svelte";
    import Section from "$components/Section.svelte";
    import { highlights } from "$stores/session";
    import type { NDKTag } from "@nostr-dev-kit/ndk";
    import { slide } from "svelte/transition";
    import { debounce } from "throttle-debounce";

    let expanded = false;
    export let articlesToRender = 50;

    let renderedArticles: Map<string, NDKTag> = new Map();

    const selectArticles = debounce(300, (count: number) => {
        const highlightedArticles = new Set<NDKTag>();

        for (const highlight of $highlights.values()) {
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
</script>

<div transition:slide={{ axis: 'y'}}>
    <Section
        title="Recently Highlighted"
        on:click={() => { expanded = true; }}
        {expanded}
    >
        <TagContentCards tags={Array.from(renderedArticles.values())} />
    </Section>
</div>
