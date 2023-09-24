<script lang="ts">
    import { networkFollows } from '$stores/session';
    import { slide } from "svelte/transition";
    import Section from "$components/Section.svelte";
    import { onDestroy, onMount } from 'svelte';
    import { derived } from 'svelte/store';
    import { newArticles } from '$stores/articles';
    import ArticleWideCard from '$components/articles/ArticleWideCard.svelte';

    export let articlesToRender = 12;

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
    <div transition:slide>
        <Section
            title="New Content"
            expanded={true}
            flow="column"
            class="divide-y-2 divide-base-300 rounded-box !gap-0"
        >
            {#each $items as article (article.id)}
                <a href="/a/{article.encode()}" class="py-4 w-full">
                    <ArticleWideCard
                        class="w-full"
                        imageClass="rounded-lg"
                        titleClass="!text-2xl"
                        {article}
                        highlightCount={0}
                        usersWithInteractions={[]}
                    />
                </a>
            {/each}
        </Section>
    </div>
{/if}