<script lang="ts">
    import CloseIcon from '$lib/icons/Close.svelte';

    import { closeModal } from 'svelte-modals';
    import {ModalWrapper} from "@kind0/ui-common";
    import ModalButton from '$lib/components/ModalButton.svelte';

    export let paymentRequest: string;
</script>

<ModalWrapper title="Lightning Invoice" class="max-w-md">
    <textarea class="input">{paymentRequest}</textarea>
    <a href={`lightning:${paymentRequest}`} class="btn btn-primary">Open</a>

    <ModalButton on:click={closeModal}>
        Close
    </ModalButton>
</ModalWrapper>
