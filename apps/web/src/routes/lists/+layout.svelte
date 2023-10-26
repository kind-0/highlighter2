<script lang="ts">
    import Sidebar from "./components/Sidebar/Sidebar.svelte";
    import { ThreeColumnsLayout } from "@kind0/ui-common";
    import Navbar from "$components/Navbar/Navbar.svelte";
</script>

<ThreeColumnsLayout>
    <div slot="navbar" class="w-full">
        <Navbar />
    </div>

    <div slot="sidebar">
        <Sidebar />
    </div>

    <slot />
</ThreeColumnsLayout>
