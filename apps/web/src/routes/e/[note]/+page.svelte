<script lang="ts">
    //import { ThreeColumnsLayout } from "@kind0/ui-common";
    //import Navbar from "$components/Navbar/Navbar.svelte";
    import ThreeColumnsLayoutTmp from "$lib/_tmp/components/ThreeColumnsLayoutTmp.svelte";
    import NavbarTmp from "$lib/_tmp/components/NavbarTmp.svelte";
	import GenericEventCard from '$lib/components/events/generic/card.svelte';
    import { page } from '$app/stores';
    import type { NDKEvent } from '@nostr-dev-kit/ndk';
    import { onDestroy } from 'svelte';

    let { note } = $page.params;

    let event: NDKEvent;
    let quotes: any;

    $: note = $page.params.note;

    onDestroy(() => {
        if (quotes) quotes.unsubscribe();
    });
</script>

<svelte:head>
	<title>{note ?? "Highlighter"}</title>
	<meta name="description" content="Unleash valuable words from their artificial silos" />
</svelte:head>

<ThreeColumnsLayoutTmp>
    <div slot="navbar">
        <NavbarTmp />
    </div>

    {#key note}
        <GenericEventCard
            bech32={note}
            skipTitle={false}
            bind:event
        />
    {/key}
</ThreeColumnsLayoutTmp>
