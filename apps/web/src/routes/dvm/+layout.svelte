<script lang="ts">
    import { ThreeColumnsLayout } from "@kind0/ui-common";
    import Sidebar from "../web/components/Sidebar/Sidebar.svelte";
    import Navbar from "$components/Navbar/Navbar.svelte";
</script>

<ThreeColumnsLayout>
    <Navbar slot="navbar" />

    <div slot="sidebar">
        <Sidebar />
    </div>

    <slot />
</ThreeColumnsLayout>