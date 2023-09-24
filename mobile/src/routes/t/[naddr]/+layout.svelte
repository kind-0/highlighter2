<script lang="ts">
    import { page } from "$app/stores";
    import Navbar from '$lib/components/Navbar/Navbar.svelte';
    import Sidebar from "$components/sidebars/ReaderSidebar.svelte";
    import { ThreeColumnsLayout, ndk } from "@kind0/ui-common";
    import type { NDKList } from "@nostr-dev-kit/ndk";

    let naddr: string;

    $: naddr = $page.params.naddr;
</script>

<ThreeColumnsLayout>
    <div slot="navbar">
        <Navbar />
    </div>

    <div slot="sidebar">
        <Sidebar />
    </div>

    {#key naddr}
        <slot />
    {/key}
</ThreeColumnsLayout>
