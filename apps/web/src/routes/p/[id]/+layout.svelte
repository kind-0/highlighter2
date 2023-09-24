<script lang="ts">
    import { page } from "$app/stores";
    import type { NDKUser } from "@nostr-dev-kit/ndk";
    import { ThreeColumnsLayout, ndk } from "@kind0/ui-common";
    import { startUserView, userSubscription } from "$stores/user-view.js";
    import { onDestroy, onMount } from "svelte";
    import Section from "$components/Section.svelte";
    import TagContentCards from "$components/ContentCards/TagContentCards.svelte";
    import Navbar from "$components/Navbar/Navbar.svelte";
    import Sidebar from "./Sidebar/Sidebar.svelte";

    let npub = $page.data.npub;
    let user: NDKUser;

    $: npub = $page.data.npub;

    onMount(() => {
        user = $ndk.getUser({npub});

        startUserView(user);
    });

    onDestroy(() => {
        userSubscription?.unsubscribe();
    })
</script>

<ThreeColumnsLayout>
    <div slot="navbar">
        <Navbar />
    </div>

    <div slot="sidebar">
        {#if user}
            <Sidebar {user} />
        {/if}
    </div>

    <slot />
</ThreeColumnsLayout>