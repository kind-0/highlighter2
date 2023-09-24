<script lang="ts">
    import AddToShelfModal from "$lib/modals/AddToShelfModal.svelte";
    import type { NDKEvent } from "@nostr-dev-kit/ndk";
    import { Book } from "phosphor-svelte";
    import { openModal } from "svelte-modals";

    export let event: NDKEvent;

    function click() {
        openModal(AddToShelfModal, { event });
    }
</script>

<button class="tooltip {$$props.class}" on:click|preventDefault|stopPropagation={click} data-tip="Add to Curation">
    {#if $$slots.default}
        <slot />
    {:else}
        <span class="flex flex-row gap-2">
            <Book />
            Add to Shelf
        </span>
    {/if}
</button>