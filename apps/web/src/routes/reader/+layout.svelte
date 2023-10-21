<script lang="ts">
    import Navbar from '$components/Navbar/Navbar.svelte';
    import ReaderSidebar from '$components/sidebars/ReaderSidebar.svelte'
    import { ThreeColumnsLayout } from '@kind0/ui-common';
</script>

<ThreeColumnsLayout>
    <div slot="navbar" class="w-full">
        <Navbar />
    </div>

    <div slot="sidebar" class="w-full">
        <ReaderSidebar />
    </div>

    <slot />
</ThreeColumnsLayout>

