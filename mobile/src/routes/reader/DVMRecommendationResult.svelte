<script lang="ts">
    import { loadingScreen } from "$stores/session";
    import type { NDKDVMJobResult, NDKTag } from "@nostr-dev-kit/ndk";
    import TagContentCards from "$components/ContentCards/TagContentCards.svelte";

    export let jobResult: NDKDVMJobResult

    let tags: NDKTag[] | undefined;

    // $loadingScreen = false;

    try {
        tags = JSON.parse(jobResult.content);

        // make unique based on the second element of the tuple
        tags = tags?.filter((e: NDKTag, i: number, a: NDKTag[]) => a.findIndex((f: NDKTag) => f[1] === e[1]) === i);
    } catch (e) {
        console.error(`failed to parse content`, e);
    }
</script>

{#if tags}
    <TagContentCards {tags} />
{/if}