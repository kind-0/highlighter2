<script lang="ts">
    import { CaretRight, CaretLeft } from "phosphor-svelte";
    import { onMount } from "svelte";
    import { slide } from "svelte/transition";

    let scrollContainer: HTMLElement;
    export let title: string;
    export let flow: 'grid' | 'column' = 'grid';

    let showLeftCaret = false;

    function scrollRight() {
        scrollContainer.scrollBy({ left: +500, behavior: 'smooth' });
    }

    function scrollLeft() {
        scrollContainer.scrollBy({ left: -500, behavior: 'smooth' });
    }

    onMount(() => {
        function handleScroll() {
            showLeftCaret = scrollContainer.scrollLeft > 0;
        }
        scrollContainer.addEventListener('scroll', handleScroll);
        return () => {
            scrollContainer.removeEventListener('scroll', handleScroll);
        };
    });
</script>

<div class="flex flex-col gap-4 w-full">
    <div class="flex flex-col lg:flex-row items-start justify-start lg:justify-between lg:items-center max-lg:pt-4 px-4 lg:px-0 gap-4">
        <h1 class="text-4xl font-bold">
            {title}
        </h1>
        <slot name="actions" />
    </div>

    <div class="flex flex-row relative">
        {#if flow === 'grid' && showLeftCaret}
            <button class="text-base-100-content absolute left-0 transition-all z-20 duration-300 right-0 top-0 bottom-0 p-2" class:opacity-0={!showLeftCaret} on:click={scrollLeft} transition:slide={{axis:'x'}}>
                <CaretLeft weight="bold" size={36} />
            </button>
        {/if}

        <div class="overflow-x-scroll scrollbar-hide">
            {#if flow === 'grid'}
                <div
                    class="absolute left-0 top-0 bottom-0 z-10 bg-gradient-to-l from-transparent via-black/80 to-black/100 w-24 h-full transition-all duration-300"
                    class:hidden={!showLeftCaret}
                ></div>

                {#if flow === 'grid'}
                    <div class="absolute right-0 top-0 bottom-0 z-10 bg-gradient-to-r from-transparent via-black/80 to-black/100 w-24 h-full"></div>
                {/if}
            {/if}

            <div class="overflow-x-auto pb-4 px-2 lg:px-0 scrollbar-hide" bind:this={scrollContainer}>
                <div class="{flow === 'grid' ? 'grid grid-flow-col auto-cols-max' : 'flex flex-col items-start justify-stretch'} gap-4">
                    <slot />
                </div>
            </div>
        </div>

        {#if flow === 'grid'}
            <button class="absolute text-base-100-content right-0 top-0 bottom-0 p-2 z-10" on:click={scrollRight}>
                <CaretRight weight="bold" size={36} />
            </button>
        {/if}
    </div>
</div>
