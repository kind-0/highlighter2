<script lang="ts">
    import { page } from "$app/stores";
    import type { NDKUser } from "@nostr-dev-kit/ndk";
    import { ThreeColumnsLayout, ndk } from "@kind0/ui-common";
    import { startUserView, userSubscription } from "$stores/user-view.js";
    import { onDestroy, onMount } from "svelte";
    import Sidebar from "./Sidebar/Sidebar.svelte";
    import Navbar from "$components/Navbar/Navbar.svelte";

    //let npub = $page.data.npub;
    let user: NDKUser;

    $: npub = $page.data.npub;

    onMount(() => {
        user = $ndk.getUser({npub});

        startUserView(user);
    });

    onDestroy(() => {
        userSubscription.unref();
    })
</script>

{#if user}
    {#key user.pubkey}
        <ThreeColumnsLayout>
            <Navbar slot="navbar" />
            <Sidebar {user}  slot="sidebar" />
            <slot />
        </ThreeColumnsLayout>
    {/key}
{/if}
