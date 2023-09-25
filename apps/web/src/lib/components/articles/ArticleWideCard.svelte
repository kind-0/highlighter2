<script lang="ts">
    import AddToShelfButton from "$components/buttons/AddToShelfButton.svelte";
    import Curation from "$icons/Curation.svelte";
    import { Avatar, AvatarWithName, BookmarkIcon, HighlightIcon, LazyLoadedImage, LinkToProfile, RelativeTime, ZapsButton, ndk } from "@kind0/ui-common";
    import type { Hexpubkey, NDKArticle } from "@nostr-dev-kit/ndk";
    import { EventContent } from "@nostr-dev-kit/ndk-svelte-components";
    import { ListPlus } from "phosphor-svelte";
    import { openModal } from "svelte-modals";

    export let article: NDKArticle;
    export let highlightCount: number | undefined = undefined;
    export let usersWithInteractions: Hexpubkey[] | undefined = undefined;

    let image = article.image;

    if (!image) {
        article.author?.fetchProfile().then(profile => {
            console.log(profile)
            image = profile.banner;
        });
    }

    function chooseRandomImage() {
        const images = [
            "https://cdn.satellite.earth/aaf65dd621667c75162ce3ee845a8202bdf2aee8d70ec0f1d25fe92ecd881675.png",
            "https://cdn.satellite.earth/c50267d41d5874cb4e949e7bd472c2d06e1b297ffffac19b2f53c291a3e052d2.png",
            "https://cdn.satellite.earth/011dc8958f86dc12c5c3a477de3551c3077fb8e71a730b7cec4a678f5c021550.png",
            "https://cdn.satellite.earth/797f48e7f20d24fca9ac385c36778e644b3a1b5b9b64c65266a5e2f7aa0e5d50.png",
        ];

        return images[Math.floor(Math.random() * images.length)];
    }

    if (!image) {
        image = chooseRandomImage();
    }

</script>

<div class="flex flex-row gap-4 rounded-box justify-start {$$props.class || ``}">
    <figure class="rounded-lg bg-base-300 {$$props.imageClass}">
        {#key image}
            <LazyLoadedImage
                image={image}
                class="{$$props.imageClass} rounded-lg"
            />
        {/key}
    </figure>

    <div class="body flex flex-col gap-0">
        <div class="flex flex-col lg:flex-row items-start justify-between gap-4 lg:gap-0">
            <div class="flex flex-row flex-wrap items-center gap-2 lg:gap-8">
                <LinkToProfile user={article.author}>
                    <AvatarWithName
                        pubkey={article.author.hexpubkey}
                        avatarClass="w-6 h-6 rounded-full"
                        nameClass="text-normal"
                    />
                </LinkToProfile>

                <RelativeTime
                    timestamp={article.published_at * 1000}
                    class="text-sm"
                />
            </div>

            <div class="flex flex-col lg:flex-row lg:items-center justify-end gap-4 lg:gap-8 items-end">
                <div class="flex flex-row items-center gap-2">
                    <ZapsButton
                        event={article}
                        class="btn btn-ghost btn-sm p-1 !rounded-full px-3 font-light !text-xs"
                    />
                    {#if highlightCount}
                        <button
                            class="btn btn-ghost btn-sm p-1 !rounded-full px-3 font-light !text-xs"
                        >
                            <HighlightIcon class="w-4 h-4" />
                            {highlightCount}
                        </button>
                    {/if}

                    <AddToShelfButton
                        event={article}
                        class="tooltip-left"
                    >
                        <ListPlus />
                    </AddToShelfButton>
                </div>

                {#if usersWithInteractions && usersWithInteractions.length > 0}
                    <div class="avatar-group -space-x-4">
                        {#each usersWithInteractions.slice(0, 3) as user}
                            <Avatar
                                pubkey={user}
                                class="w-8 h-8 rounded-full"
                            />
                        {/each}
                        {#if usersWithInteractions.length > 3}
                            <span class="w-8 h-8 rounded-full badge badge-neutral z-50">
                                +{usersWithInteractions.length - 3}
                            </span>
                        {/if}
                    </div>
                {/if}
            </div>
        </div>

        <div class="flex flex-col gap-2">
            <h1 class="text-3xl card-title {$$props.titleClass}">{article.title??"Untitled"}</h1>
            {#if article.summary}
                <div class="summary">{article.summary}</div>
            {:else}
                <div class="summary">
                    <EventContent
                        ndk={$ndk}
                        event={article}
                        content={article.content.slice(0, 200)}
                    />
                </div>
            {/if}
        </div>
    </div>
</div>

<style lang="postcss">
    figure {
        width: 250px;
    }

    .body {
        @apply !py-0 col-span-3 w-full;
    }

    .summary {
        @apply text-base opacity-60;
    }

    .sm:card-wide {
        @apply card-side;
    }
</style>