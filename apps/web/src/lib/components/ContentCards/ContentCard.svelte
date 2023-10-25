<script lang="ts">
    import type { NDKEvent } from "@nostr-dev-kit/ndk";
    import ZapCounter from "./ZapCounter.svelte";
    import { LazyLoadedImage } from "@kind0/ui-common";

    export let title: string | undefined;
    export let summary: string | undefined;
    export let image: string | undefined;
    export let url: string = "#";
    export let event: NDKEvent | undefined = undefined;

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



<div class="flex flex-col gap-4 w-[166px] {$$props.class??""}">
    <!-- group class -->
    <a href={url} class="relative opacity-90 hover:opacity-100 overflow-hidden flex flex-col justify-end h-[244px] w-full shadow rounded-xl">
        <div class="absolute top-0 left-0 h-full w-full rounded-xl">
            {#if image}
                <LazyLoadedImage {image} />
            {/if}
        </div>

        <div class="absolute top-4 left-4 flex w-auto h-auto justify-center items-center rounded-lg bg-base-300 overflow-hidden">
            <slot name="icon"/>
        </div>

        <div class="w-full mx-0 h-[90px] group-hover:h-full flex flex-col p-4 bg-base-300 bg-opacity-70 backdrop-blur-[22px] transition-all duration-300 rounded-b-xl group-hover:rounded-xl">
            <div class="max-h-14">
                <p class="title text-base-100-content text-xs whitespace-normal font-medium leading-[18px]">{title}</p>
            </div>
            <!-- <div class="hidden group-hover:flex flex-col flex-grow justify-between pt-2 gap-2.5 transition-all duration-300">
                <div>
                    {#if summary}
                    <p class="summary text-xs font-normal leading-[18px] whitespace-normal">{summary}</p>
                    {/if}
                </div>
                {#if event}
                    <ZapCounter {event} />
                {/if}
            </div> -->
        </div>
    </a>

    <div class="flex w-full px-2 justify-start items-center">
        <slot name="footer" />
    </div>
</div>

<style>
    .title {
        width: 100%;
        display: -webkit-box;
        -webkit-box-orient: vertical;
        -webkit-line-clamp: 3;
        overflow: hidden;
    }
    .summary {
        width: 100%;
        display: -webkit-box;
        -webkit-box-orient: vertical;
        -webkit-line-clamp: 6;
        overflow: hidden;
    }
</style>