<script lang="ts">
    import { user, userFollows, highlights } from "$stores/session";
    import type { NDKHighlight } from "@nostr-dev-kit/ndk";
    import { onDestroy, onMount } from "svelte";
    import HighlightList from "$lib/components/HighlightList.svelte";
    import { derived, type Readable } from "svelte/store";
    import { goto } from '$app/navigation';

    let sortedStore: Readable<NDKHighlight[]>;

    onMount(() => {
        if (!$user) {
            goto('/');
            return;
        }

        const currentPubkey = $user.hexpubkey;

        sortedStore = derived(highlights, ($highlights) => {
            return Array.from($highlights.values())
                .filter(h => h.pubkey === currentPubkey)
                .sort((a, b) => {
                    return b.created_at! - a.created_at!;
                })
                .slice(0, 20)
        })
    })
</script>

<HighlightList items={$sortedStore} />