<script lang="ts">
    import { page } from "$app/stores";

    import Newest from './newest.svelte';
    import Highlights from './highlights.svelte';
    import { browser } from '$app/environment';

    let { scope, ordering } = $page.params;

    $: {
        scope = $page.params.scope;
        ordering = $page.params.ordering;
    }

    $: if (scope === 'network' && browser) {
    }
</script>

{#if ordering === 'newest'}
    <Newest />
{:else if ordering === 'highlights'}
    <Highlights />
{/if}