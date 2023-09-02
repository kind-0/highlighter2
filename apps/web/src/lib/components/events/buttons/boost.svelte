<script lang="ts">
	import type { NDKEvent } from '@nostr-dev-kit/ndk';

    import { openModal } from 'svelte-modals'
    import BoostModal from '$lib/modals/Boost.svelte';
    import { user } from '$stores/session';
    import { Repeat } from 'phosphor-svelte';

    export let event: NDKEvent;

    let tooltip: string;

    $: tooltip = $user ? 'Boost' : 'You are not logged in';
</script>

<div class="tooltip" data-tip={tooltip}>
    <button class="w-4 h-4 {$$props.class}"
    class:cursor-not-allowed={!$user}
    on:click={() => { if (!$user) return; openModal(BoostModal, { id: event.encode(), event }) }}>
        <Repeat />
    </button>
</div>
