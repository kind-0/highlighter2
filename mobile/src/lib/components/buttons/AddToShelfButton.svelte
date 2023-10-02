<script lang="ts">
    import AddToShelfModal from "$lib/modals/AddToShelfModal.svelte";
    import type { NDKEvent } from "@nostr-dev-kit/ndk";
    import { Book } from "phosphor-svelte";
    import { openModal } from "svelte-modals";

    export let event: NDKEvent;
    export let onButtonClick = async () => {return}
    export let onModalClose = async () => {return}

    async function click() {
        await onButtonClick()
        openModal(AddToShelfModal, { event, onModalClose });
    }
</script>

<button class="tooltip {$$props.class || ``}" on:click|preventDefault|stopPropagation={click} data-tip="Add to Curation">
    {#if $$slots.default}
        <slot />
    {:else}
        <span class="flex flex-row gap-2">
            <Book />
            Add to Shelf
        </span>
    {/if}
</button>