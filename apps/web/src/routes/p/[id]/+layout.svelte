<script lang="ts">
    import { page } from "$app/stores";
    import type { NDKUser } from "@nostr-dev-kit/ndk";
    import { ndk } from "@kind0/ui-common";
    import { startUserView, userSubscription } from "$stores/user-view.js";
    import { onDestroy, onMount } from "svelte";
    import Sidebar from "./Sidebar/Sidebar.svelte";
    import PageContainer from "$components/PageContainer.svelte";
    import { page_loading } from "$stores/page_loading";

    //let npub = $page.data.npub;
    let user: NDKUser;

    $: npub = $page.data.npub;

    onMount(() => {
        $page_loading = true;
        user = $ndk.getUser({npub});

        startUserView(user);
        $page_loading = false;
    });

    onDestroy(() => {
        userSubscription?.unsubscribe();
    })
</script>

<PageContainer>
    <div slot="leftSidebar">
        <Sidebar {user} />
    </div>
    <slot />
</PageContainer>

<!---<ThreeColumnsLayout>
    <div slot="navbar">
        <Navbar />
    </div>

    <div slot="sidebar">
        {#if user}
            <Sidebar {user} />
        {/if}
    </div>

    <slot />
</ThreeColumnsLayout>-->