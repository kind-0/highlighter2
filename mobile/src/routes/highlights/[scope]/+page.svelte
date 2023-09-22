<script lang="ts">
    import { page } from "$app/stores";

    import Newest from '../newest.svelte';
    import { ndk } from "@kind0/ui-common";
    import { NDKHighlight } from "@nostr-dev-kit/ndk";
    import type { NDKEventStore } from "@nostr-dev-kit/ndk-svelte";
    import { onDestroy } from "svelte";
    import { derived, type Readable } from "svelte/store";
    import { user, highlights, userFollows } from "$stores/session";

    let { scope } = $page.params;

    $: {
        scope = $page.params.scope;
        console.log({scope});
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

    $: {

        console.log('updating', scope);
        switch (scope) {
        case "local":
            store = localHighlights;
            break;
        case "me":
            console.log(`User: ${$user.hexpubkey}`);
            store = derived(highlights, $highlights => {
                let map = new Map();

                for (let [key, h] of $highlights.entries()) {
                    if (h.pubkey === $user.hexpubkey) {
                        map.set(key, h);
                    }
                }

                return Array.from(map.values());
            });
            break;
        case "":
            store = derived(highlights, $highlights => {
                let map = new Map();

                for (let [key, h] of $highlights.entries()) {
                    if ($userFollows.has(h.pubkey)) {
                        map.set(key, h);
                    }
                }

                return Array.from(map.values());
            });
            break;
    }

}
</script>

{scope}

{#if store}
    <Newest highlights={store} />
{/if}