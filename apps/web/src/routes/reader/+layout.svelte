<script lang="ts">
    import Sidebar from '$components/sidebars/ReaderSidebar.svelte'
    import Navbar from "$components/Navbar/Navbar.svelte";
    import { ThreeColumnsLayout } from "@kind0/ui-common";
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