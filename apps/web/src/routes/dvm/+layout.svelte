<script lang="ts">
    import { ThreeColumnsLayout } from "@kind0/ui-common";
    import Sidebar from "../web/components/Sidebar/Sidebar.svelte";
    import Navbar from "$components/Navbar/Navbar.svelte";
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