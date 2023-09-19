<script lang="ts">
    //
</script>

<div class="flex flex-col min-h-screen w-full">
    {#if $$slots.navbar}
        <slot name="navbar" />
    {/if}
    <div class="flex flex-col w-full">
        <slot />
    </div>
</div>
