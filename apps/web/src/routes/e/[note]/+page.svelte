<script lang="ts">
    import { ResponsiveColumnsLayout, ResponsiveLogoNavbar } from "@kind0/ui-common";
	import GenericEventCard from '$lib/components/events/generic/card.svelte';
    import { page } from '$app/stores';
    import type { NDKEvent } from '@nostr-dev-kit/ndk';
    import { onDestroy } from 'svelte';
    import { user } from "$stores/session";
    import { AtlasNotesLogo } from "@kind0/ui-common";
    import FullLogo from "$lib/icons/FullLogo.svelte";
    import Logo from "$lib/icons/Logo.svelte";
    import CurrentUser from "$lib/components/CurrentUser.svelte";
    import SearchInput from "$lib/components/Navbar/SearchInput.svelte";

    let { note } = $page.params;

    let event: NDKEvent;
    let quotes: any;

    $: note = $page.params.note;

    onDestroy(() => {
        if (quotes) quotes.unsubscribe();
    });


    let homeLink = "/";
    $: homeLink = $user ? `/reader` : "/";

    let currentRoute: string;
    let logoToUse: any = FullLogo;

    $: currentRoute = $page.url.pathname;
    $: if (currentRoute.startsWith("/lists") || currentRoute.startsWith("/notes")) {
        logoToUse = AtlasNotesLogo;
    } else {
        logoToUse = FullLogo;
    }
</script>

<svelte:head>
	<title>{note ?? "Highlighter"}</title>
	<meta name="description" content="Unleash valuable words from their artificial silos" />
</svelte:head>

<ResponsiveColumnsLayout>
    <div slot="navbar">
        <ResponsiveLogoNavbar {homeLink}>
            <div slot="logo">
                <div class="flex hidden sm:block">
                    <svelte:component this={logoToUse} />
                </div>
                <div class="flex sm:hidden">
                    <Logo />
                </div>
            </div>
            <div slot="main">
                <div class="flex flex-row w-full flex-1 justify-end items-center">
                    <div class="hidden lg:block flex flex-row w-full">
                        <SearchInput />
                    </div>
                    <div class="flex flex-row w-auto">
                        <CurrentUser />
                    </div>
                </div>
            </div>
        </ResponsiveLogoNavbar>
    </div>

    {#key note}
        <GenericEventCard
            bech32={note}
            skipTitle={false}
            bind:event
        />
    {/key}
</ResponsiveColumnsLayout>
