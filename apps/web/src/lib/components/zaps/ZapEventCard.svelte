<script lang="ts">
    import EventCard from '$lib/components/events/card.svelte';

    import { zapInvoiceFromEvent, type NDKEvent, type NDKZapInvoice, NDKUser } from '@nostr-dev-kit/ndk';
    import { nicelyFormattedMilliSatNumber } from "@kind0/ui-common";
    import { onDestroy, onMount } from 'svelte';
    import type { NDKEventStore } from '@nostr-dev-kit/ndk-svelte';
    import { ndk } from "@kind0/ui-common";

    export let event: NDKEvent;
    export let skipFooter = false;
    export let skipButtons = false;
    export let skipReplies = false;
    export let expandReplies = true
    export let draggable = true;

    let modifiedEvent: NDKEvent = event;
    let zap: NDKZapInvoice;

    let replies: NDKEventStore<NDKEvent>;

    onMount(() => {
        zap = zapInvoiceFromEvent(event);

        if (zap) {
            modifiedEvent.author = new NDKUser({hexpubkey: zap.zappee});
        }

        if (!skipReplies) {
            replies = $ndk.storeSubscribe(
                { kinds: [1], '#e': [event.id] },
                { closeOnEose: true, groupableDelay: 1500, subId: "ZapEventCard" }
            );
        }
    });

    onDestroy(() => {
        if (replies) replies.unsubscribe();
    });
</script>

{#if zap}
    <EventCard
        event={modifiedEvent}
        skipHeader={true}
        {skipFooter}
        {skipButtons}
        {skipReplies}
        {draggable}
        replies={($replies||[])}
        {expandReplies}
    >
            <div class="text-xl font-semibold">
                <span class="text-gray-500">⚡️ {nicelyFormattedMilliSatNumber(zap.amount)} sats zap</span>
            </div>

            <div class="text-gray-500">
                <span class="text-gray-500">{zap.comment}</span>
            </div>
    </EventCard>
{/if}