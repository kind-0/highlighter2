<script lang="ts">
    import MainWithRightSidebar from "$lib/layouts/MainWithRightSidebar.svelte";
    import { user, userFollows, highlights } from "$stores/session";
    import type NDKHighlight from "$lib/ndk-kinds/highlight";
    import { onMount } from "svelte";
    import HighlightList from "$lib/components/HighlightList.svelte";
    import { derived, type Readable } from "svelte/store";
    import { goto } from '$app/navigation';

    let sortedStore: Readable<NDKHighlight[]>;

    onMount(() => {
        if (!$user) {
            goto(`/highlights/global`);
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

<MainWithRightSidebar>
    <HighlightList items={$sortedStore} />
</MainWithRightSidebar>