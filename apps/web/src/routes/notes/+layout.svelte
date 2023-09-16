<script lang="ts">
    import { page } from '$app/stores';
    import Sidebar from "$components/sidebars/AtlasSidebar.svelte";
    import { user } from '$stores/session';
    import { getLongForms } from '$lib/stores/long-form';
    import { onDestroy } from 'svelte';
    import type { NDKSubscription } from '@nostr-dev-kit/ndk';
    import { ThreeColumnsLayout } from '@kind0/ui-common';
    import Navbar from '$components/Navbar/Navbar.svelte';

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

    <slot />
</ThreeColumnsLayout>