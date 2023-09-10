<script lang="ts">
    import { openModal } from 'svelte-modals';
    import LoginNip46Modal from './LoginNip46Modal.svelte';
    import { SubtleButton } from "@kind0/ui-common";

    async function openNip46Modal() {
        // Close dropdown
        if (document.activeElement instanceof HTMLElement) {
            document.activeElement.blur();
        }

        openModal(LoginNip46Modal);
    }
</script>

<SubtleButton on:click={openNip46Modal} class="w-full">
    <span>nsecBunker</span>
</SubtleButton>
