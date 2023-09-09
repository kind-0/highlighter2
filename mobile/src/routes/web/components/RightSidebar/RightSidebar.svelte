<script lang="ts">
	import { NDKDVMJobResult, NDKDVMRequest, NDKEvent, NDKKind } from '@nostr-dev-kit/ndk';
    import MenuItem from "$components/sidebars/MenuItem.svelte";
    import {ndk} from "@kind0/lib-svelte-kit";
    import { onMount } from 'svelte';

    let requests: Map<string, NDKEvent>;
    let jobResponses: Set<NDKEvent>;

    onMount(async () => {
        const recentRequests = await $ndk.fetchEvents(
            { kinds: [NDKKind.DVMJobRequestTranscription], limit: 100 }
        );

        requests = new Map(Array.from(recentRequests).map((r: NDKEvent) => [r.tagId(), r]));

        jobResponses = await $ndk.fetchEvents(
            {
                kinds: [NDKKind.DVMJobResult],
                "#e": Array.from(recentRequests).map((r: NDKEvent) => r.tagId())
            }
        );
    });

    function jobRequest(response: NDKEvent) {
        const input = response.tagValue("e");
        if (!input) return;
        return requests.get(input);
    }

</script>

{#if jobResponses && jobResponses.size > 0}
    <ul class="menu bg-base-200 w-full rounded-box overflow-hidden">
        <li class="menu-title uppercase">Recent transcriptions</li>

        {#each Array.from(jobResponses) as jobResponse (jobResponse.id)}
            {#if jobRequest(jobResponse)}
                <MenuItem href="/highlights/network">
                    <div class="flex flex-row gap-2 items-center">
                        <span class="truncate">
                            {jobRequest(jobResponse)?.tagValue("i")}
                        </span>
                    </div>
                </MenuItem>
            {/if}
        {/each}
    </ul>
{/if}