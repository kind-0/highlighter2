<script lang="ts">
    import { openModal } from 'svelte-modals'

    import ZapIcon from '$lib/icons/Zap.svelte';

    import ZapModal from '$lib/modals/Zap.svelte';
    import { onDestroy } from 'svelte';
    import { type NDKEvent, zapInvoiceFromEvent } from '@nostr-dev-kit/ndk';
    import { nicelyFormattedMilliSatNumber } from '$lib/utils';
    import { user } from '$stores/session';
    import ndk from '$stores/ndk';
    import type { NDKEventStore } from '@nostr-dev-kit/ndk-svelte';

    export let event: NDKEvent;
    let eventId: string;
    let zaps: NDKEventStore<NDKEvent>;
    export let zappedAmount: number = 0;

    onDestroy(() => {
        if (zaps) zaps.unsubscribe();
    });

    $: if (event?.id && event.id !== eventId) {
        eventId = event.id;
        zaps?.unsubscribe();

        zaps = $ndk.storeSubscribe(
            { kinds: [ 9735 ], '#e': [event.id] },
            { closeOnEose: false, groupableDelay: 1000, subId: "zaps-button" }
        );
    }

    let zappedByCurrentUser: boolean = false;

    $: if ($zaps) {
        zappedAmount = $zaps.reduce((acc: number, zap: NDKEvent) => {
            const zapInvoice = zapInvoiceFromEvent(zap);
            if (!zapInvoice) return acc;

            if (zapInvoice.zappee === $user?.hexpubkey) {
                zappedByCurrentUser = true;
            }

            return acc + zapInvoice.amount;
        }, 0);
    }

    let tooltip: string;
    $: tooltip = $user ? 'Zap' : 'You are not logged in';

</script>

{#if event?.id && $user}
    <div class="tooltip flex flex-row items-center gap-1.5" data-tip={tooltip}>
        <button
            class="flex flex-row items-center gap-1.5"
            class:cursor-not-allowed={!$user}
            on:click={() => { openModal(ZapModal, { event }) }}
        >
            <ZapIcon class="
                w-4 h-4
                {zappedByCurrentUser ? 'text-primary-500' : ''}
                {$$props.class}" />
            {#if zappedAmount > 0}
                <div class="
                text-sm
                {zappedByCurrentUser ? 'text-primary-500' : ''}
                ">{nicelyFormattedMilliSatNumber(zappedAmount)}</div>
            {/if}
        </button>
    </div>
{/if}
