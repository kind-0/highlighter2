<script lang="ts">
    import { goto } from '$app/navigation';
    import HighlightList from '$lib/components/HighlightList.svelte';
    import HighlightListItem from '$components/HighlightListItem.svelte';
    import FullLogo from '$icons/FullLogo.svelte';
    import { user, userFollowHashtags, userFollows } from '$stores/session';
    import { Avatar, HighlightIcon, Input, PrimaryButton, ndk } from "@kind0/ui-common";
    import { NDKEvent, type NostrEvent, NDKHighlight, NDKUser, type Hexpubkey, NDKKind } from '@nostr-dev-kit/ndk';
    import RecentlyHighlighted from './reader/RecentlyHighlighted.svelte';
    import { onDestroy, onMount } from 'svelte';
    import { startUserView, userSubscription } from '$stores/user-view';
    import SupportCustomPlan from '$modals/SupportCustomPlan.svelte';
    import { slide } from 'svelte/transition';
    import LoginGuestButton from '$lib/ndk-svelte-components/LoginGuestButton.svelte';
    import Navbar from '$components/Navbar/Navbar.svelte';
    import LoginNip07Button from '$lib/ndk-svelte-components/LoginNip07Button.svelte';
    import LoginNip46Button from '$lib/ndk-svelte-components/LoginNip46Button.svelte';
    import { derived } from 'svelte/store';
    import type { NDKEventStore } from '@nostr-dev-kit/ndk-svelte';

    const selectedTopics = [
        "education",
        "worldschooling",
        "unschooling",
        "learning"
    ];

    const gigi = $ndk.getUser({npub: "npub1dergggklka99wwrs92yz8wdjs952h2ux2ha2ed598ngwu9w7a6fsh9xzpc"});

    const nevent1qqs95nrtg47d0urtw8lzrellvrt4tlyzrs75vxs98gl6r5lju50xdvcpp4mhxue69uhkummn9ekx7mqsy2wxv = new NDKEvent($ndk, { "id": "5a4c6b457cd7f06b71fe21e7ff60d755fc821c3d461a053a3fa1d3f2e51e66b3", "pubkey": "fa984bd7dbb282f07e16e7ae87b26a2a7b9b90b7246a44771f0cf5ae58018f52", "created_at": 1698224365, "kind": 9802, "tags": [ [ "a", "30023:6e468422dfb74a5738702a8823b9b28168abab8655faacb6853cd0ee15deee93:1680612926599" ], [ "e", "1a1fe6c838400f3347f97a9adce08c10068f3bc35a279520c911b025c387b061" ], [ "p", "6e468422dfb74a5738702a8823b9b28168abab8655faacb6853cd0ee15deee93" ], [ "p", "6e468422dfb74a5738702a8823b9b28168abab8655faacb6853cd0ee15deee93" ], [ "p", "b9e76546ba06456ed301d9e52bc49fa48e70a6bf2282be7a1ae72947612023dc" ], [ "context", "Now, imagine that users are able to highlight passages. These highlights, just like bookmarks now, could be private or public. When shared publicly, something interesting emerges: an overlay on existing content, a lens on the written Web. In other words: swarm highlights." ], [ "t", "nostr" ], [ "t", "reading" ], [ "t", "writing" ], [ "t", "readability" ], [ "t", "highlights" ], [ "t", "pocket" ], [ "t", "instapaper" ], [ "t", "readwise" ], [ "t", "disqus" ], [ "t", "v4v" ], [ "alt", "\"Now, imagine that users are able to highlight passages. These highlights, just like bookmarks now, could be private or public. When shared publicly, something interesting emerges: an overlay on existing content, a lens on the written Web. In other words: swarm highlights.\"\n\nThis is a highlight created on https://highlighter.com" ], [ "zap", "6e468422dfb74a5738702a8823b9b28168abab8655faacb6853cd0ee15deee93", "wss://purplepag.es", "2" ], [ "zap", "fa984bd7dbb282f07e16e7ae87b26a2a7b9b90b7246a44771f0cf5ae58018f52", "wss://purplepag.es", "1" ] ], "content": "Now, imagine that users are able to highlight passages. These highlights, just like bookmarks now, could be private or public. When shared publicly, something interesting emerges: an overlay on existing content, a lens on the written Web. In other words: swarm highlights.", "sig": "16fbfb2a0dd3e922af286b335d2420e7476202e1a0da98263615f407d7dcc7e548df9250fa86e3ceefed62bec81de36565fc64747b009e4a055249016d9affc4" })

    let supportedCreators: Set<NDKUser> = new Set();

    const recentHighlights: NDKEventStore<NDKHighlight> = $ndk.storeSubscribe([
        {
            kinds: [NDKKind.Highlight],
            limit: 50
        }
    ], undefined, NDKHighlight);
    const highlights = derived(recentHighlights, ($recentHighlights) => {
        const h = new Map<string, NDKHighlight>();

        for (const event of $recentHighlights) {
            h.set(event.id, event);
        }

        return h;
    });

    onMount(async () => {
        startUserView(gigi);

        $ndk.fetchEvents({ kinds: [7001 as number] }).then((events) => {
            let pubkeys = new Set<Hexpubkey>();

            for (const e of events) {
                try {
                    const pTag = e.tagValue('p');

                    if (pTag && !pubkeys.has(pTag)) {
                        const user = $ndk.getUser({pubkey: pTag});
                        supportedCreators.add(user);
                    }
                } catch (e: any) {}
            }

            supportedCreators = supportedCreators;
        });
    });

    onDestroy(() => {
        userSubscription.unref();
    })

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

<div class="z-50 fixed top-0 mx-auto w-full">
    <Navbar />
</div>

<div class="mt-[80px]"></div>

<div class="blurred-circle"></div>

<div class="fixed bottom-0 left-0  bg-gradient-to-t from-black w-full h-48 z-50">
</div>

<main class="mx-auto flex flex-col gap-48 place-items-center px-2 md:px-0 overflow-x-clip pb-24">
    <section class="min-h-[80vh] py-10 flex flex-col items-center justify-center text-base-100-content max-w-prose gap-8 xl:gap-10 md:text-center">
        <p>
            We all encounter thousands of words each day
        </p>

        <div class="grid grid-cols-2 gap-8 md:flex md:flex-row justify-end md:justify-between md:w-full">
            <div class="badge badge-accent !text-xl p-4">podcasts</div>
            <div class="badge bg-accent2 text-accent-content !text-xl p-4">articles</div>
            <div class="badge badge-primary !text-xl p-4">books</div>
            <div class="badge badge-info !text-xl p-4">short notes</div>
        </div>

        <p>
            yet knowledge, dare I say, <em>wisdom</em>, eludes us.
        </p>

        <p>
            you've arrived at a tool that aims to help you make sense out of the chaos.
            A tool to mute the noise and zero-in on the signal.
        </p>

        <div class="max-w-96">
            <FullLogo />
        </div>

        <div transition:slide={{axis:'y'}}>
            <HighlightListItem
                highlight={NDKHighlight.from(nevent1qqs95nrtg47d0urtw8lzrellvrt4tlyzrs75vxs98gl6r5lju50xdvcpp4mhxue69uhkummn9ekx7mqsy2wxv)}
                class="text-left border-2 border-accent/20 rounded-box"
            />
        </div>
    </section>

    <section class="py-10 flex flex-col items-center gap-8 xl:gap-10 w-full min-h-screen">
        <div class="flex flex-col items-center justify-center lg:text-center">
            <div class="uppercase text-accent text-lg lg:text-xl tracking-widest font-semibold">Highlights</div>
            <div class="text-base-100-content text-4xl lg:text-7xl font-bold whitespace-nowrap">
                Capture every passage
            </div>
        </div>

        <div class="w-full lg:w-main lg:mb-20">
            {#await $ndk.fetchEvent("note14kycajxkfnzz0tujmuszfj7tz3mlm93qdk58hemtg9uf968n5cjqrwnu3h")}
            {:then highlight}
                {#if highlight}
                    <div transition:slide={{axis:'y'}}>
                        <HighlightListItem
                            highlight={NDKHighlight.from(highlight)}
                        />
                    </div>
                {/if}
            {/await}
        </div>

        <div class="flex flex-col md:flex-row gap-32 max-w-5xl min-h-screen">
            <div class="lg:w-1/2 text-base-100-content text-xl heading-10 flex flex-col gap-4 sticky top-20 h-fit">
                <div class="sticky">
                    <mark>Highlights</mark>
                    <HighlightIcon class="inline-block w-6 h-6 text-accent -mt-6" />
                    are the basic construct.</div>

                <div>A way to quickly capture the ideas that resonate with you and inspire your thoughts.</div>
            </div>
            <div class="lg:w-1/2 overflow-clip h-[150vh]">
                <div class="mockup-browser bg-base-300 w-main">
                    <div class="mockup-browser-toolbar">
                        <div class="input">highlighter.com</div>
                    </div>
                    <div class="flex justify-center px-4 bg-base-200">
                        {#if $recentHighlights}
                            <HighlightList items={Array.from($recentHighlights).slice(10)} containerStyle={`w-32`} />
                        {/if}
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="py-10 flex flex-col items-center gap-8 xl:gap-10 w-full h-screen">
        <div class="flex flex-col items-center justify-center lg:text-center">
            <div class="uppercase text-accent text-lg lg:text-xl tracking-widest font-semibold">
                Unmatched Discovery
            </div>
            <div class="text-base-100-content text-4xl lg:text-7xl font-bold whitespace-nowrap">
                Find your next favorite read
            </div>
        </div>

        <div class="max-w-5xl lg:mb-20">
            <RecentlyHighlighted {highlights} skipTitle={true} />
        </div>

        <div class="flex flex-col md:flex-row gap-32 max-w-5xl">
            <div class="lg:w-1/2 text-base-100-content text-xl heading-10 flex flex-col gap-4">
                <div>
                    <em>
                        <mark>"Have you read anything interesting lately?"</mark>
                        <HighlightIcon class="inline-block w-6 h-6 text-accent -mt-6" />
                    </em>
                </div>

                <div>
                    Relying on your close friends and people you look up to is a battle-tested way to find insightful content.
                </div>

                <div>
                    Because Highlighter is built on top of
                    <span class="text-accent">Nostr</span>, your social circle
                    is immediately available, and highlighly relevant.
                </div>
            </div>
            <div class="lg:w-1/2">
                {#await $ndk.fetchEvent("nevent1qqs9rs75q96heucddlgsgst9scl602v2qkjv7jsqvdhkw42zysw7h2cpp4mhxue69uhkummn9ekx7mqrp9056")}
                {:then highlight}
                    {#if highlight}
                        <div transition:slide={{axis:'y'}}>
                            <HighlightListItem
                                highlight={NDKHighlight.from(highlight)}
                            />
                        </div>
                    {/if}
                {/await}
            </div>
        </div>
    </section>

    <section class="py-10 flex flex-col items-center gap-8 xl:gap-10 w-full min-h-screen">
        <div class="flex flex-col items-center justify-center lg:text-center">
            <div class="uppercase text-accent text-lg lg:text-xl tracking-widest font-semibold">
                Creators and you; nothing in between
            </div>
            <div class="text-base-100-content text-4xl lg:text-7xl font-bold whitespace-nowrap">
                Support your favorite creators
            </div>
        </div>

        <div class="w-full lg:w-main lg:mb-20">
            {#await $ndk.fetchEvent("nevent1qqsze48lt6mnzknxwcj8ha7qhp40pfkg7smaq6pd7tlzh8v2mkh897spp4mhxue69uhkummn9ekx7mqe2ug3m")}
            {:then highlight}
                {#if highlight}
                    <div transition:slide={{axis:'y'}}>
                        <HighlightListItem
                            highlight={NDKHighlight.from(highlight)}
                        />
                    </div>
                {/if}
            {/await}
        </div>

        <div class="flex flex-col md:flex-row gap-32 max-w-5xl">
            <div class="lg:w-1/2 text-base-100-content text-xl heading-10 flex flex-col gap-4">
                <div>
                    Through <span class="text-accent">Nostr</span>, readers and creators can interact directly.
                    No intermmediaries.
                </div>

                <div>
                    This direct interaction informs the creators' work, and the creator can be rewarded for their work. The lines between the two are blurred.
                </div>

                <div>
                    <mark>
                        Leveraging open-source, freedom-enabling technologies, we are able to counteract the
                        censorship, deplatforming and unnecessary middlemen that plague current systems.
                    </mark>
                    <HighlightIcon class="inline-block w-6 h-6 text-accent -mt-6" />
                </div>
            </div>
            <div class="lg:w-1/2">
                {#await gigi.fetchProfile() then profile}
                    <div class="relative rounded-box flex flex-col items-center justify-center p-8">
                        {#if profile?.banner}
                            <div class="absolute top-0 left-0 h-full w-full opacity-20">
                                <div class="relative h-[300px] w-full overflow-hidden">
                                    <img src={profile?.banner} alt="Banner" class="absolute inset-0 w-full h-full object-cover banner rounded-xl">
                                    <div class="absolute inset-x-0 bottom-0 h-[100%] bg-gradient-to-t from-base-200 to-transparent" />
                                </div>
                            </div>
                        {/if}

                        <div class="z-50 flex flex-col items-center">
                            <Avatar user={gigi} {profile} type="square" class="w-24 h-24 -mb-4 z-20" />

                            <SupportCustomPlan selectedValue={10} />
                        </div>
                    </div>
                {/await}
            </div>
        </div>

        {#if supportedCreators}
            <div class="flex flex-row flex-wrap avatar-group justify-center gap-6">
                {#each Array.from(supportedCreators) as creator (creator.pubkey)}
                    {#await creator.fetchProfile() then profile}
                        {#if profile}
                            <a href="/p/{profile.nip05}">
                                <span class="tooltip" data-tip={profile.name}>
                                    <Avatar user={creator} size="medium" type="square" />
                                </span>
                            </a>
                        {/if}
                    {/await}
                {/each}
            </div>
        {/if}
    </section>

    <section class="py-10 flex flex-col items-center gap-8 xl:gap-10 w-full min-h-screen">
        <div class="flex flex-col items-center justify-center lg:text-center">
            <div class="uppercase text-accent text-lg lg:text-xl tracking-widest font-semibold">
                Protocols over platforms
            </div>
            <div class="text-base-100-content text-4xl lg:text-7xl font-bold whitespace-nowrap">
                Not yet another platform
            </div>
        </div>

        <div class="w-full lg:w-main lg:mb-20">
            {#await $ndk.fetchEvent("nevent1qqsdukusq0e42m8z9dsvm33vqunfhxumsytkrm9h2fn9a7frk7trkeqpp4mhxue69uhkummn9ekx7mqn2jq8g")}
            {:then highlight}
                {#if highlight}
                    <div transition:slide={{axis:'y'}}>
                        <HighlightListItem
                            highlight={NDKHighlight.from(highlight)}
                        />
                    </div>
                {/if}
            {/await}
        </div>

        <div class="flex flex-col md:flex-row gap-32 max-w-5xl">
            <div class="lg:w-1/2 text-base-100-content text-xl heading-10 flex flex-col gap-4">
                <div>
                    <em>
                        <mark>"Another one of these? Really?"</mark>
                    </em>
                </div>

                <div>
                    <em>Yes. Really.</em>
                </div>

                <div>
                    This problem hasn't been solved. Not due to a lack of trying, but rather a gruesome technological gap.
                </div>

                <div>
                    The problem is simple and hard. Platforms become obsolete: something better comes along. Incentives change. The platform you've been using for years is gone. And so is your data.
                </div>

                <div>
                    Highlighter takes a different approach. It holds exactly zero data.
                </div>

                <div>
                    All data is stored in the
                    <span class="text-accent">Nostr</span> protocol, which is a roundabout way of saying that your highlights, your notes, your social interactions, they all belong to you.
                </div>
            </div>
            <div class="lg:w-1/2">
                <img src="/images/meme.png" />
            </div>
        </div>
    </section>

    <section class="max-w-3xl w-full min-h-[40vh]">
        {#if !$user}
            <div class="card w-full">
                <div class="card-body">
                    <div class="flex flex-col md:flex-row">
                        <div class="lg:w-1/2 flex flex-col gap-8">
                            <div class="card-title text-base-100-content whitespace-nowrap">
                                New to Nostr?
                            </div>

                            <div class="text-sm">
                                Nostr is a simple, open protocol that enables global, decentralized, and censorship-resistant social media.
                            </div>

                            <LoginGuestButton />
                        </div>

                        <div class="divider md:divider-horizontal"></div>

                        <div class="lg:w-1/2 flex flex-col gap-8">
                            <div class="card-title text-base-100-content whitespace-nowrap">
                                Already have an account?
                            </div>

                            <LoginNip07Button />
                            <LoginNip46Button />
                        </div>
                    </div>
                </div>
            </div>
        {:else}
            <PrimaryButton
                href="/reader"
                class="!text-2xl !px-20 py-4 !h-auto"
            >
                Explore Highlighter
            </PrimaryButton>
        {/if}
    </section>
</main>

<style lang="postcss">
    .blurred-circle {
        position: fixed;
        width: 30vw;
        height: 30vh;
        z-index: -50;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        background: radial-gradient(circle at center, #FF685E, #817EFF, black);
        filter: blur(50px);
        opacity: 0.1;
        animation: pulsate 5s infinite alternate ease-in-out;
    }

    @keyframes pulsate {
        0% {
            transform: translate(-50%, -50%) scale(1);
            opacity: 0.1;
        }
        100% {
            transform: translate(-50%, -50%) scale(1.1);
            opacity: 0.4;
        }
    }

    p {
        @apply text-2xl text-base-100-content opacity-90 tracking-wide leading-10;
    }
</style>