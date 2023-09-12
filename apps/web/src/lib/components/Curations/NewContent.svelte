<script lang="ts">
	import { networkFollows } from '$stores/session';
    import { newArticles } from '$stores/articles';
    import { onDestroy, onMount } from 'svelte';
    import ArticleContentCard from '$components/ContentCards/ArticleContentCard.svelte';
    import { derived } from 'svelte/store';

    export let articlesToRender = 12;
    export let expanded = false;

    newArticles.onEose(() => {
        console.log(`newArticles unref`);
    });

    const items = derived(newArticles, $newArticles => {
        let existingIds = new Set<string>();
        let items = $newArticles;
        let selectedItems = [];

        // if we have a network graph, filter by it
        if ($networkFollows && $networkFollows.size > 1000) {
            items = items.filter(a => $networkFollows.has(a.pubkey))
        };

        // dedup
        for (const item of items) {
            // We don't dedup by the event's encode() because some users sometimes publish the same thing twice accidentally
            const id = item.title + item.pubkey;
            if (!existingIds.has(id)) {
                selectedItems.push(item);
                existingIds.add(id);
            }

            if (selectedItems.length >= articlesToRender) {
                break;
            }
        }

        return selectedItems;
    });

    onMount(() => {
        newArticles.ref();
    })

    onDestroy(() => {
        newArticles.unref();
    });
</script>

{#if $items}
    {#each $items as article (article.id)}
        <div class="flex items-center justify-center">
            <ArticleContentCard {article} />
        </div>
    {/each}
{/if}
