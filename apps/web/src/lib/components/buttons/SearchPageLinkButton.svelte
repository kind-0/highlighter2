<script lang="ts">
    export let buttonText = ``
</script>

<a href="/search" class="btn btn-neutral btn-xs {$$props.class}">
    {#if $$slots.default}
        <slot />
    {:else}
        {buttonText || `Return to search`}
    {/if}
</a>