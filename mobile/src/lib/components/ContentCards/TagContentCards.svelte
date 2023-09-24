<script lang="ts">
    import type { NDKEventId, NDKTag } from "@nostr-dev-kit/ndk";
    import TagContentCard from "./TagContentCard.svelte";

    export let tags: NDKTag[];

    let loadedArticleIds = new Set<NDKEventId>();
    let loadedArticles = new Set<NDKTag>();

    function readyToRender(tag: NDKTag) {
        loadedArticleIds.add(tag[1]);
        loadedArticles.add(tag);
        loadedArticleIds = loadedArticleIds;
        loadedArticles = loadedArticles;
    }
</script>

{#each Array.from(loadedArticles) as tag}
    <TagContentCard {tag} />
{/each}

<div class="hidden">
    {#each tags as tag}
        {#if !loadedArticleIds.has(tag[1])}
            <TagContentCard tag={tag} on:loaded={() => readyToRender(tag)} />
        {/if}
    {/each}
</div>