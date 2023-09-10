<script lang="ts">
	import { networkFollows } from '$stores/session';
    import { newArticles } from '$stores/articles';
    import type { NDKArticle } from '@nostr-dev-kit/ndk';
    import { onDestroy, onMount } from 'svelte';
    import { debounce } from 'throttle-debounce';
    import { createEventDispatcher } from "svelte";
    import ArticleContentCard from '$components/ContentCards/ArticleContentCard.svelte';

    export let items: NDKArticle[];
    export let articlesToRender = 12;
    export let expanded = false;

    const dispatch = createEventDispatcher();

    const updatedRenderedArticles = debounce(300, (newArticles: NDKArticle[]) => {
        let items = newArticles;

        // if we have a network graph, filter by it
        if ($networkFollows) {
            items = items.filter(a => $networkFollows.has(a.pubkey))
        };

        // dedup
        items = items.slice(0, articlesToRender);
    });

    $: if ($newArticles || articlesToRender) updatedRenderedArticles($newArticles);

    onMount(() => {
        newArticles.ref();
    })

    onDestroy(() => {
        newArticles.unref();
    });

    let loadedAuthors = 0;

    function authorLoaded() {
        loadedAuthors++;

        if (loadedAuthors === items.length) {
            dispatch('ready');
        }
    }
</script>

<br>

{#if items}
    <div class="
        {expanded ? "grid grid-flow-row grid-cols-2 md:grid-cols-4 gap-4" : "grid grid-flow-col auto-cols-max"} gap-4"
    >
        {#each items as article (article.id)}
            <div class="flex items-center justify-center">
                <ArticleContentCard {article} on:author-loaded={authorLoaded} />
            </div>
        {/each}
    </div>
{/if}