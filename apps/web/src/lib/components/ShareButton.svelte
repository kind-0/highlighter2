<script lang="ts">
    import { app_share } from "$stores/app_share";
    import { Share, type ShareOptions } from "@capacitor/share";

    export let options: ShareOptions
    export let showIcon = true
    export let onShareEndCallback = () => {return}

    async function main() {
        try {
            if(!$app_share) {
                console.log(`highlighter: share not enabled`);
                return
            }

            if(!options) {
                console.log(`share missing options`);
                return
            }
            await Share.share(options);
        } catch (e) {
            console.log(`share error: `, e);   
        } finally {
            onShareEndCallback()
        }
    }
</script>

<button type="button" class="{$$props.class}" on:click|preventDefault={async () => await main()}>
    {#if $$slots.default}
        <slot />
    {/if}
    {#if showIcon}
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-4 h-4">
            <path stroke-linecap="round" stroke-linejoin="round" d="M16.5 8.25V6a2.25 2.25 0 00-2.25-2.25H6A2.25 2.25 0 003.75 6v8.25A2.25 2.25 0 006 16.5h2.25m8.25-8.25H18a2.25 2.25 0 012.25 2.25V18A2.25 2.25 0 0118 20.25h-7.5A2.25 2.25 0 018.25 18v-1.5m8.25-8.25h-6a2.25 2.25 0 00-2.25 2.25v6" />
        </svg>
    {/if}
</button>