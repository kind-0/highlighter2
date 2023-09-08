<script lang="ts">
    import MainWithRightSidebar from "$lib/layouts/MainWithRightSidebar.svelte";
    import { user, userFollows, highlights } from "$stores/session";
    import { NDKHighlight } from "@nostr-dev-kit/ndk";
    import { onMount } from "svelte";
    import HighlightList from "$lib/components/HighlightList.svelte";
    import { derived, type Readable } from "svelte/store";
    import { goto } from '$app/navigation';

    let sortedStore: Readable<NDKHighlight[]>;

    onMount(() => {
        if (!$user) {
            goto(`/highlights/local`);
            return;
        }

        sortedStore = derived(highlights, ($highlights) => {
            return Array.from($highlights.values())
                .filter(h => $userFollows.has(h.pubkey))
                .sort((a, b) => {
                    return b.created_at! - a.created_at!;
                })
                .slice(0, 20);
        });
    })
</script>

{#if sortedStore && $sortedStore}
    <MainWithRightSidebar>
        <HighlightList items={$sortedStore} />
    </MainWithRightSidebar>
{/if}