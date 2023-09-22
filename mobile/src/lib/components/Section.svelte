<script lang="ts">
    import { slide } from "svelte/transition";

    export let title: string;
    export let expanded: boolean = false;
    export let flow: 'grid' | 'column' = 'grid';
</script>

<div class="flex flex-col gap-4">
    <div class="flex flex-col lg:flex-row items-start justify-start lg:justify-between lg:items-center px-4 lg:px-0 gap-4 lg:gap-0">
        <h1 class="text-4xl font-bold">
            {title}
        </h1>
        <slot name="actions" />
    </div>

    <div class="relative">
        <div class="overflow-x-auto pb-4 px-2 lg:px-0 scrollbar-hide">
            <div class="
                {flow === 'grid' ?
                    expanded ? "grid grid-flow-row grid-cols-2 md:grid-cols-4 gap-4" : "grid grid-flow-col auto-cols-max"
                : "flex flex-col items-start justify-stretch"
            } gap-4 {$$props.class}" transition:slide={{axis:'y'}}>
                <slot />
            </div>
        </div>
        {#if !expanded}
            <div class="
                absolute right-0 top-0 bottom-0 bg-gradient-to-r w-24 from-transparent to-base-100/80 z-1 h-full
            ">
                <div class="opacity-0 hover:opacity-100 flex flex-col items-center justify-center w-full h-full transition-all duration-200 group p-4">
                    <button class="bg-base-300 text-base-300-content p-2 rounded-box" on:click>
                        View more
                    </button>
                </div>
            </div>
        {/if}
    </div>
</div>