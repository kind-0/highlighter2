<script lang="ts">
    import JobStatus from '$lib/components/jobs/status/JobStatus.svelte';
    import { onDestroy } from "svelte";
    import type { NDKEvent, NDKDVMRequest } from "@nostr-dev-kit/ndk";
    import { ndk } from "@kind0/ui-common";
    import type { NDKEventStore } from '@nostr-dev-kit/ndk-svelte';

    export let jobRequest: NDKDVMRequest;
    export let onlyJobsWithResults = false;
    let subscribedToJobId: string | undefined;

    let jobEvents: NDKEventStore<NDKEvent>;
    let dvms: Record<string, NDKEventStore<NDKEvent>>;

    function subscribeToJob() {
        if (jobEvents) unsubscribeFromJob();

        jobEvents = $ndk.storeSubscribe({
            kinds: [1,5,7, 9735, 65000 as number, 65001 as number],
            ...jobRequest.filter()
        }, { closeOnEose: false, groupable: onlyJobsWithResults });

        subscribedToJobId = jobRequest.id;
    }

    $: if (jobEvents && $jobEvents) {
        pubkeyGroupedJobEvents = {};
        $jobEvents.forEach((event: NDKEvent) => {
            const pubkey = event.pubkey;
            if (!pubkeyGroupedJobEvents[pubkey]) {
                pubkeyGroupedJobEvents[pubkey] = [];
            }

            pubkeyGroupedJobEvents[pubkey].push(event);
        });

        pubkeyGroupedJobEvents = pubkeyGroupedJobEvents;
    }

    function unsubscribeFromJob() {
        if (jobEvents) jobEvents.unsubscribe();
        subscribedToJobId = undefined;
    }

    $: if (jobRequest?.id && subscribedToJobId !== jobRequest.id)
        subscribeToJob();

    onDestroy(() => {
        unsubscribeFromJob();
    })
</script>

{#if pubkeyGroupedJobEvents}
    <div class="flex flex-col gap-4 w-main">
        {#each Object.keys(pubkeyGroupedJobEvents) as pubkey}
            <JobStatus {pubkey} {onlyJobsWithResults} events={pubkeyGroupedJobEvents[pubkey]} />
        {/each}
    </div>
{/if}
