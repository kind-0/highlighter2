<script lang="ts">
	import Navbar from '$lib/components/Navbar/Navbar.svelte';
    import Sidebar from "$components/sidebars/HighlightsSidebar.svelte";
    import {ThreeColumnsLayout} from "@kind0/ui-common";
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
