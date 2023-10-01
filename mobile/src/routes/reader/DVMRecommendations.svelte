<script lang="ts">
    import { ndk } from "@kind0/ui-common";
    import { NDKDVMRequest, NDKKind, NDKUser, NDKEvent, NDKAppHandlerEvent, NDKDVMJobResult, type NDKTag, NDKArticle } from "@nostr-dev-kit/ndk";
    import Section from "$components/Section.svelte";
    import { user, userDVMRequests, userDVMResults } from "$stores/session";
    import { contentDiscoveryApps } from "@kind0/ui-common";
    import { Avatar } from "@kind0/ui-common";
    import DvmRecommendationResult from "./DVMRecommendationResult.svelte";
    import { slide } from "svelte/transition";

    const highlighterRecommendationsDVM = new NDKUser({npub: "npub1w0rthyjyp2f5gful0gm2500pwyxfrx93a85289xdz0sd6hyef33sh2cu4x"});

    let request: NDKEvent | undefined = undefined;
    let selectedDVM: NDKAppHandlerEvent | undefined = undefined;

    let fallbackRecommendationEvents: NDKDVMJobResult[];

    // Let's start with a hardcoded set of user interests
    const userInterest = ['philosophy', 'seneca', 'stoicism'];

    function selectResult(e: NDKDVMJobResult) {
        try {
            return JSON.parse(e.content).length > 0;
        } catch (e) { return false; }
    }

    $ndk.fetchEvents({
        kinds: [NDKKind.DVMJobResult],
        authors: [highlighterRecommendationsDVM.hexpubkey],
        "#p": [
            "fa984bd7dbb282f07e16e7ae87b26a2a7b9b90b7246a44771f0cf5ae58018f52"
        ]
    }).then((events) => {
        fallbackRecommendationEvents = Array.from(events)
            .map(e => NDKDVMJobResult.from(e))
            .filter(selectResult);
    });

    let recommendation: NDKDVMJobResult | undefined = undefined;

    // By default, select the highlighter recommendations DVM -- change this to obey the user's NIP-89 event
    $: if (!selectedDVM && $contentDiscoveryApps) {
        selectedDVM = $contentDiscoveryApps.find(h => h.pubkey === highlighterRecommendationsDVM.hexpubkey);
    }

    /** Check if we have requests of kind 65008 that we can reuse for the initial load */
    $: if ($userDVMRequests.get(65008) && $userDVMRequests.get(65008)!.length > 0 && !request) {
        request = $userDVMRequests.get(65008)![0];

        // check if the request was served
        if ($userDVMResults.get(request.id)) {
            console.log(`request was served`);
            recommendation = $userDVMResults.get(request.id)![0];
        } else {
            console.log(`request was not served`);
            request = undefined;
        }
    }

    $: if (!request && selectedDVM && !!$user) requestRecommendation(selectedDVM);

    async function requestRecommendation(appHandlerEvent: NDKAppHandlerEvent) {
        const dvmPubkey = appHandlerEvent.pubkey;
        selectedDVM = appHandlerEvent;

        request = new NDKDVMRequest($ndk);
        request.kind = NDKKind.DVMNostrContentRecommendation;
        request.tags.push(["p", dvmPubkey]);

        for (const interest of userInterest) {
            request.tags.push(["param", "t", interest]);
        }

        await request.sign();
        await request.publish();
        request = request;
    }

    $: if (request?.id) {
        const results = $userDVMResults.get(request.id);

        console.log('dvm results', results);

        if (results) {
            recommendation = results
                .filter(selectResult)
                .find((e: NDKDVMJobResult) => e.pubkey === selectedDVM?.pubkey);
        }
    }

    let expanded = false;
</script>

{#if selectedDVM && fallbackRecommendationEvents}
    <div transition:slide={{ axis: 'y'}}>
        <Section
            title="Suggested Content"
            on:click={() => { expanded = true; }}
            {expanded}
        >
            <div slot="actions" class="flex flex-col w-full">
                <!-- svelte-ignore a11y-label-has-associated-control -->
                <div class="dropdown">
                    <!-- svelte-ignore a11y-no-noninteractive-tabindex -->
                    <label tabindex="0" class="btn !rounded-full px-6">
                        {#if !selectedDVM}
                            Choose
                            <span class="font-semibold text-base-100-content">
                                Recommendation Provider
                            </span>
                        {:else}
                            {#await selectedDVM.fetchProfile() then profile}
                                From
                                <span class="font-semibold text-base-100-content">
                                    {profile?.name}
                                </span>
                            {/await}
                        {/if}
                    </label>
                    <!-- svelte-ignore a11y-no-noninteractive-tabindex -->
                    <ul tabindex="0" class="dropdown-content z-[1] menu mt-2 p-2 shadow bg-base-100 rounded-xl max-lg:w-full w-fit">
                        {#each $contentDiscoveryApps as contentDiscoveryApp}
                            {#await contentDiscoveryApp.fetchProfile() then profile}
                                <li>
                                    <button
                                        on:click={() => requestRecommendation(contentDiscoveryApp)}
                                        disabled={!$user}
                                    >
                                        <div
                                            class="flex flex-row gap-4"
                                            class:cursor-not-allowed={!$user}
                                            class:tooltip={!$user}
                                            data-tip="You need to be logged in"
                                        >
                                            <Avatar ndk={$ndk} userProfile={profile} type="circle" class="w-12 h-12" />
                                            <div class="flex flex-col gap-2">
                                                <div class="text-base max-lg:text-left whitespace-nowrap truncate text-base-100-content">
                                                    {profile?.name}
                                                </div>
                                                <div class="text-xs text-left">
                                                    {profile?.about}
                                                </div>
                                            </div>
                                        </div>
                                    </button>
                                </li>
                            {/await}
                        {/each}
                    </ul>
                </div>
            </div>

            {#if recommendation}
                <DvmRecommendationResult jobResult={recommendation} />
            {:else if fallbackRecommendationEvents?.length > 0}
                <DvmRecommendationResult jobResult={fallbackRecommendationEvents[0]} />
            {/if}
        </Section>
    </div>
{/if}