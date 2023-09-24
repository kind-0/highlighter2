<script lang="ts">
    import type { NDKEventId, NDKTag } from "@nostr-dev-kit/ndk";
    import TagContentCard from "./TagContentCard.svelte";

    export let tags: NDKTag[];
</script>

{#each tags.slice(0, 50) as tag}
    <TagContentCard
        tag={tag}
        on:loaded
    />
{/each}