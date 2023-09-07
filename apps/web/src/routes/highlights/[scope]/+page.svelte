<script lang="ts">
    import { page } from "$app/stores";

    import Newest from './newest.svelte';
    import { ndk } from "@kind0/lib-svelte-kit";
    import NDKHighlight from "$lib/ndk-kinds/highlight";
    import type { NDKEventStore } from "@nostr-dev-kit/ndk-svelte";
    import { onDestroy } from "svelte";
    import { derived, type Readable } from "svelte/store";
    import { highlights, userFollows } from "$stores/session";

    let { scope, ordering } = $page.params;

    $: {
        scope = $page.params.scope;
        ordering = $page.params.ordering;
    }

    /**
     * Highlights either come from the session store or the localHighlights,
     * which is specific to this page
     */
    const localHighlights = $ndk.storeSubscribe(
        { kinds: [9802], limit: 10 },
        { closeOnEose: false, groupable: false, subId: "local-highlights" },
        NDKHighlight
    );

    onDestroy(() => {
        console.log(`Unsubscribing from localHighlights`);
        localHighlights.unsubscribe();
    });

    let store: NDKEventStore<NDKHighlight> | Readable<NDKHighlight[]>;

    $: switch (scope) {
        case "local":
            store = localHighlights;
            break;
        case "":
            store = derived(highlights, $highlights => {
                let map = new Map();

                for (let [key, h] of $highlights.entries()) {
                    if ($userFollows.has(h.pubkey)) {
                        map.set(key, h);
                    }
                }

                return map;
            });
            break;
    }
</script>

{#if store}
    <Newest highlights={store} />
{/if}