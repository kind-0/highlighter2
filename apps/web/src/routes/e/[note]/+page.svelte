<script lang="ts">
	import GenericEventCard from '$lib/components/events/generic/card.svelte';
    import { page } from '$app/stores';
    import type { NDKEvent } from '@nostr-dev-kit/ndk';
    import { onDestroy } from 'svelte';
    import { user } from "$stores/session";
    import { AtlasNotesLogo } from "@kind0/ui-common";
    import FullLogo from "$lib/icons/FullLogo.svelte";

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

{#key note}
    <GenericEventCard
        bech32={note}
        skipTitle={false}
        bind:event
    />
{/key}