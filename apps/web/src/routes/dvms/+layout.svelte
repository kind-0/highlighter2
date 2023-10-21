<script lang="ts">
	import Navbar from '$lib/components/Navbar/Navbar.svelte';
    import Sidebar from "$components/sidebars/DvmsSidebar.svelte";
    import {ThreeColumnsLayout} from "@kind0/ui-common";
</script>

<ThreeColumnsLayout>
    <Navbar slot="navbar" />

    <div slot="sidebar" class="w-full">
        <Sidebar />
    </div>

    <slot />
</ThreeColumnsLayout>
