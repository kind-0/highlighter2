<script lang="ts">
    import { page } from '$app/stores';
    import Sidebar from "../lists/components/Sidebar/Sidebar.svelte";
    import WithLeftSidebar from "$lib/layouts/WithLeftSidebar.svelte";
    import { ndk } from "@kind0/lib-svelte-kit";
    import { user } from '$stores/session';
    import { getLongForms } from '$lib/stores/long-form';
    import { onDestroy } from 'svelte';
    import type { NDKSubscription } from '@nostr-dev-kit/ndk';
    import { ThreeColumnsLayout } from '@kind0/ui-common';
    import Navbar from '$components/Navbar/Navbar.svelte';

    let readyToRender = true;

    $: if ($user && $ndk.signer) {
        readyToRender = true;
    }

    const pagesWithHiddenSidebar = [
        '/notes/new',
        '/notes/[naddr]/edit',
    ];

    let forceHideSidebar = false;

    $: forceHideSidebar = pagesWithHiddenSidebar.includes($page.route.id);

    let subscribed = false;
    let encryptedNotesSub: NDKSubscription | undefined = undefined;

    $: if (!subscribed && $user) {
        subscribed = true;
        encryptedNotesSub = getLongForms($user);
    }

    onDestroy(() => {
        if (encryptedNotesSub) {
            encryptedNotesSub.stop();
        }
    });
</script>

<ThreeColumnsLayout>
    <div slot="navbar">
        <Navbar />
    </div>

    <div slot="sidebar">
        <Sidebar />
    </div>

    {#if readyToRender}
        <slot />
    {:else}
        Loading
    {/if}
</ThreeColumnsLayout>