<script lang="ts">
    import { page } from "$app/stores";
    import MainWithRightSidebar from "$lib/layouts/MainWithRightSidebar.svelte";
    import { NDKKind, NDKUser } from "@nostr-dev-kit/ndk";
    import HighlightList from "$lib/components/HighlightList.svelte";
    import { ndk } from "@kind0/ui-common";
    import { NDKHighlight } from "@nostr-dev-kit/ndk";
    import { onDestroy, onMount } from "svelte";
    import type { NDKEventStore } from "@nostr-dev-kit/ndk-svelte";

    const { npub } = $page.data;

    let user: NDKUser;
    let highlights: NDKEventStore<NDKHighlight> | undefined;

    onMount(() => {
        user = new NDKUser({npub});

        highlights = $ndk.storeSubscribe({
            kinds: [NDKKind.Highlight as number],
            authors: [user.hexpubkey]
        }, undefined, NDKHighlight);
    });

    onDestroy(() => {
        if (highlights) highlights.unsubscribe();
    });
</script>

<MainWithRightSidebar>
    {#if $highlights}
        <HighlightList items={$highlights} />
    {/if}
</MainWithRightSidebar>