<script lang="ts">
    import { nicelyFormattedSatNumber, AttentionButton } from "@kind0/ui-common";
    import { CaretDown, Lightning } from "phosphor-svelte";

    export let selectedValue = 5;
    export let bitcoinPrice: number | undefined;

    const options = [ 2, 5, 10, 20, 50, 100 ];
</script>

<div class="card !bg-transparent/60">
    <div class="card-body">
        <div class="card-title text-base-100-content">Supporter</div>
        <div class="divider -mx-4 my-0"></div>
        <div class="flex flex-row justify-between items-center">
            <div class="flex flex-row items-end gap-8">
                <span class="text-base-100-content text-lg font-semibold">
                    <div class="dropdown dropdown-top">
                        <button class="flex items-center flex-row gap-4 border-b border-base-300 pb-2">
                            <span>
                                ${selectedValue}
                                <span class="text-sm font-thin">
                                    / month
                                </span>
                            </span>
                            <CaretDown class="w-4 h-4" />
                        </button>

                        <ul class="dropdown-content menu w-full z-50 font-normal duration-1000">
                            {#each options as option}
                                {#if option !== selectedValue}
                                    <li>
                                        <button on:click={() => selectedValue = option}>
                                            ${option}
                                        </button>
                                    </li>
                                {/if}
                            {/each}
                        </ul>
                    </div>
                </span>
            </div>

            {#if bitcoinPrice}
                <div class="flex flex-row items-center text-accent2 font-base">
                    <Lightning class="text-accent2 w-4 h-4" weight="fill" />
                    {nicelyFormattedSatNumber(selectedValue * 100000000 / bitcoinPrice)}
                    sats
                </div>
            {/if}
        </div>
        <div class="divider -mx-4 my-0"></div>

        <div class="flex flex-col gap-4">
            <div class="text-base-100-content">
                <AttentionButton color="accent2" on:click>
                    Support with
                    ${selectedValue}
                    /mo
                </AttentionButton>
            </div>
        </div>
    </div>
</div>