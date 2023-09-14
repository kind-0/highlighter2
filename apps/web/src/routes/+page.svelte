<script lang="ts">
    import { goto } from '$app/navigation';
    import Navbar from '$lib/components/Navbar/Navbar.svelte';
    import ButtonWithBorderGradient2 from '$lib/components/buttons/ButtonWithBorderGradient2.svelte';
    import GenericEventCard from '$lib/components/events/generic/card.svelte';
    import { user, userFollowHashtags } from '$stores/session';
    import { ndk } from "@kind0/ui-common";
    import { NDKEvent, type NostrEvent } from '@nostr-dev-kit/ndk';

    const selectedTopics = [
        "education",
        "worldschooling",
        "unschooling",
        "learning"
    ];

    async function getStarted() {
        if ($user) {
            const followedHashtags = new NDKEvent($ndk, {
                kind: 30015,
                tags: [
                    ["d", "education"],
                    ["title", "Education"],
                    ...selectedTopics.map((t) => ["t", t]),
                    ["p", "fa984bd7dbb282f07e16e7ae87b26a2a7b9b90b7246a44771f0cf5ae58018f52", "pablof7z" ]
                ]
            } as NostrEvent);

            for (const h of $userFollowHashtags) { followedHashtags.tags.push(['t', h]); }

            await followedHashtags.sign();

            await followedHashtags.publish();

            goto('/reader');
            return;
        }

        if (window.nostr) {

        }
    }
</script>

<svelte:head>
    <title>Highlighter</title>
    <meta name="description" content="Highlighter" />
</svelte:head>

<div class="flex flex-col min-h-screen overflow-x-hidden">
    <div class="mx-auto">
        <Navbar isHiddenDrawerBtn={true} isHiddenRelayBtn={true} />
    </div>
    <div class="hero flex flex-column justify-center">
        <div class="w-full md:max-w-2xl lg:max-w-3xl mx-auto flex flex-col gap-5 md:gap-12">
            <div class="relative">
                <div class="mx-10 blur-sm text-xs md:text-base font-normal pb-1 hidden sm:block">
                    <span
                        >Here's the thing that nostr got right, and it's the same thing that Bitcoin got right: information is easy to spread and hard
                        to stifle.</span
                    ><span style="underline">1</span><span>
                        Information can be copied quickly and perfectly, which is, I believe, the underlying reason for its desire to be free.<br
                        /><br />Easy to spread, hard to stifle. That's the base reality of the nature of information. As always, the smart thing is to
                        work with nature, not against it.</span
                    ><span style="underline">2</span><span>
                        That's what's beautiful about the orange coin and the purple ostrich: both manage to work with the peculiarities of
                        information, not against them. Both realize that information can and should be copied, as it can be perfectly read and easily
                        spread, always. Both understand that resistance to censorship comes from writing to many places, making the cost of deletion
                        prohibitive.</span
                    >
                </div>
                <div class="mx-10 blur-sm text-xs md:text-base font-normal pb-1 sm:hidden">
                    <span
                        >Here's the thing that nostr got right, and it's the same thing that Bitcoin got right: information is easy to spread and hard
                        to stifle.</span
                    ><span style="underline">1</span><span>
                        Information can be copied quickly and perfectly, which is, I believe, the underlying reason for its desire to be free.<br
                        /><br />Easy to spread, hard to stifle. That's the base reality of the nature of information. As always, the smart thing is to
                        work with nature, not against it.</span
                    >
                </div>
                <div class="absolute top-0 left-0 w-full h-full bg-gradient-to-t from-transparent to-base-100" />
                <div
                    class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/3 text-4xl md:text-6xl z-1 text-center font-bold w-full"
                >
                    <!-- TODO UPDATE GRADIENT COLOR FOR LIGHT AND DARK MODE -->
                    <span class="bg-clip-text text-transparent bg-gradient-to-r from-gradient3 to-gradient4 dark:from-white dark:to-gradient4">
                        Elevate
                        Information
                        <br/>
                        to Wisdom
                    </span>
                </div>
            </div>

            <div class="px-10">
                <GenericEventCard
                    id="532808e4d60f5f82b95aeaa3ed2e930a0c5973dccb0ede68b28b1931db91440f"
                    skipTitle={false}
                    skipReplies={true}
                    skipFooter={true}
                    expandReplies={false}
                />
            </div>

            <div class="relative">
                <div class="mx-10 blur-sm text-xs md:text-base font-normal pb-1">
                    <span class="hidden sm: block"
                        >Here's the thing that nostr got right, and it's the same thing that Bitcoin got right: information is easy to spread and hard
                        to stifle.</span
                    >
                    <span style="underline hidden sm:block">1</span><span class="hidden sm:block">
                        Information can be copied quickly and perfectly, which is, I believe, the underlying reason for its desire to be free.<br
                        /><br />Easy to spread, hard to stifle. That's the base reality of the nature of information. As always, the smart thing is to
                        work with nature, not against it.</span
                    ><span style="underline">2</span><span>
                        That's what's beautiful about the orange coin and the purple ostrich: both manage to work with the peculiarities of
                        information, not against them. Both realize that information can and should be copied, as it can be perfectly read and easily
                        spread, always. Both understand that resistance to censorship comes from writing to many places, making the cost of deletion
                        prohibitive.</span
                    >
                </div>
                <div class="absolute top-0 left-0 w-full h-full bg-gradient-to-b from-transparent to-base-100" />

                <div
                    class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-3/4 text-white text-4xl md:text-6xl z-1 text-center font-bold w-full"
                >
                    <span class="bg-clip-text text-transparent bg-gradient-to-tr from-gradient4 to-gradient3">
                        What will you discover?
                    </span>
                </div>

                <ButtonWithBorderGradient2
                    class="absolute bottom-0 left-1/2 transform -translate-x-1/2 translate-y-2/3 md:translate-y-1/4 lg:translate-y-3/4"
                    innerClass="text-xl md:text-2xl font-thin px-10 py-4"
                    style="z-index: 9999"
                    on:click={getStarted}
                >
                    I enjoy reading about
                    Philosophy
                </ButtonWithBorderGradient2>
            </div>
        </div>
    </div>
</div>
