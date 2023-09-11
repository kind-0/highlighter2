<script lang="ts">
    import TagContentCard from "$components/ContentCards/TagContentCard.svelte";
    import { loadingScreen } from "$stores/session";
    import type { NDKDVMJobResult, NDKTag } from "@nostr-dev-kit/ndk";

    export let jobResult: NDKDVMJobResult

    let decodedContent: NDKTag[] | undefined;

    $loadingScreen = false;

    try {
        decodedContent = JSON.parse(jobResult.content);

        // make unique based on the second element of the tuple
        decodedContent = decodedContent?.filter((e: NDKTag, i: number, a: NDKTag[]) => a.findIndex((f: NDKTag) => f[1] === e[1]) === i);
    } catch (e) {
        console.error(`failed to parse content`, e);
    }
</script>

{#if decodedContent}
    {#each decodedContent as tag}
        <TagContentCard tag={tag} />
    {/each}
{/if}