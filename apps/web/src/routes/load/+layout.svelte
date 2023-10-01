<script lang="ts">
    import DrawerContainer from "$components/DrawerContainer.svelte";
    import DrawerNavigationLinks from "$components/DrawerNavigationLinks.svelte";
    import Navbar from "$components/Navbar/Navbar.svelte";
    import { ThreeColumnsLayout } from "@kind0/ui-common";

    //
    let openDrawer = false
</script>

<DrawerContainer visible={openDrawer}>
    <svelte:fragment slot="page">
        <ThreeColumnsLayout>
            <div slot="navbar">
                <Navbar isHiddenLogo={true} drawerOpenCallback={async () => { openDrawer = !openDrawer }} />
            </div>
        
            <slot />
        </ThreeColumnsLayout>
    </svelte:fragment>
    <svelte:fragment slot="drawer">
        <DrawerNavigationLinks />
    </svelte:fragment>
</DrawerContainer>