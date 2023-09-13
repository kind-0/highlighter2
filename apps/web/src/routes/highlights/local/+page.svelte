<script lang="ts">
    import Newest from '../newest.svelte';
    import { ndk } from "@kind0/ui-common";
    import { NDKHighlight } from "@nostr-dev-kit/ndk";
    import { onDestroy } from "svelte";

    /**
     * Highlights either come from the session store or the localHighlights,
     * which is specific to this page
     */
    const store = $ndk.storeSubscribe(
        { kinds: [9802], limit: 10 },
        { closeOnEose: false, groupable: false, subId: "local-highlights" },
        NDKHighlight
    );

    onDestroy(() => {
        console.log(`Unsubscribing from localHighlights`);
        store.unsubscribe();
    });
</script>

<main class="w-main pb-32 flex flex-col gap-6">
    <Newest highlights={store} />
</main>
