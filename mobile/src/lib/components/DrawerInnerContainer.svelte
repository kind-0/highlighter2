<script lang="ts">
    //
    export let closeDrawerCallback = async () => {return}
</script>

<div class="flex flex-col h-screen w-full justify-start items-start p-12 bg-base-100">
    <div class="flex flex-row w-full justify-start items-center pb-8">
        <button on:click={async () => await closeDrawerCallback()}>
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                <path stroke-linecap="round" stroke-linejoin="round" d="M10.5 19.5L3 12m0 0l7.5-7.5M3 12h18" />
            </svg> 
        </button>
    </div>
    <slot />
</div>