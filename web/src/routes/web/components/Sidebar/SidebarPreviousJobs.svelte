<script lang="ts">
    import ndk from "$lib/stores/ndk";
    import { type NDKFilter, NDKDVMRequest } from "@nostr-dev-kit/ndk";
    import { onMount } from "svelte";
    import SidebarJobRequestItem from "./SidebarJobRequestItem.svelte";
    import { derived, type Readable } from "svelte/store";
    import type { NDKEventStore } from "@nostr-dev-kit/ndk-svelte";

    let previousJobs: NDKEventStore<NDKDVMRequest>;
    let sortedJobs: Readable<NDKDVMRequest[]>;

    onMount(() => {
        const query: NDKFilter = { kinds: [65002 as number], limit: 10 };

        if ($user) {
            query.authors = [$user.hexpubkey()];
        }

        previousJobs = $ndk.storeSubscribe(
            query,
            { closeOnEose: false },
            NDKDVMRequest
        );

        sortedJobs = derived(previousJobs, ($previousJobsStore) =>
            $previousJobsStore.sort((a, b) => a.created_at! - b.created_at!)
        );
    });

</script>

{#if $previousJobs?.length > 0}
    <li class="menu-title">PREVIOUS JOBS</li>

    {#each $previousJobs as jobRequest}
        <SidebarJobRequestItem {jobRequest} />
    {/each}
{/if}
