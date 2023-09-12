<script lang="ts">
    import { slide } from "svelte/transition";

    export let title: string;
    export let expanded: boolean = false;
</script>

<div class="flex flex-col gap-4">
    <div class="flex flex-row items-center justify-between">
        <h1 class="text-4xl font-bold">
            {title}
        </h1>
        <slot name="actions" />
    </div>

    <div class="relative">
        <div class="overflow-x-auto pb-4">
            <div class="{expanded ? "grid grid-flow-row grid-cols-2 md:grid-cols-4 gap-4" : "grid grid-flow-col auto-cols-max"} gap-4" transition:slide={{axis:'y'}}>
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