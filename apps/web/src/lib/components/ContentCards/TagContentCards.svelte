<script lang="ts">
    import type { NDKEventId, NDKTag } from "@nostr-dev-kit/ndk";
    import TagContentCard from "./TagContentCard.svelte";

    export let tags: NDKTag[];

    let loadedArticles = new Set<NDKTag>();

    function readyToRender(tag: NDKTag) {
        loadedArticles.add(tag);
        loadedArticles = loadedArticles;
    }
</script>

{#each tags.slice(0, 10) as tag}
    <TagContentCard
        tag={tag}
        on:loaded={(article) => readyToRender(tag)}
    />
{/each}