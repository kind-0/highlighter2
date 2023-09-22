<script lang="ts">
    import Navbar from "$components/Navbar/Navbar.svelte";
    import { ThreeColumnsLayout } from "@kind0/ui-common";

    
</script>

<ThreeColumnsLayout>
    <div slot="navbar">
        <Navbar />
    </div>

    <slot />
</ThreeColumnsLayout>