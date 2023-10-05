<script lang="ts">
    //
    import ReaderSidebar from '$components/sidebars/ReaderSidebar.svelte'
    import MobileTabs from "$components/MobileTabs.svelte";
    import { page_drawer } from "$stores/page_drawer";
    import { page_mobiletabs } from "$stores/page_mobiletabs";
    import { LoadingSpinner, ThreeColumnsLayout } from "@kind0/ui-common";
    import DrawerContainer from "./DrawerContainer.svelte";
    import DrawerNavigationLinks from "./DrawerNavigationLinks.svelte";
    import Navbar from './Navbar/Navbar.svelte';
    import { onMount } from 'svelte';
    import { page_navbar } from '$stores/page_navbar';
    import { navigating } from '$app/stores';

    export let hideNavbar = false
    //export let pageClass = ``
    //export let mainClass = ``
    export let pageOverflowHidden = false
    export let pageLoading = false

    let mounted = false

    onMount(async () => {
        mounted = true
    })
</script>

{#if $navigating}
    <div class="flex flex-col h-[calc(100vh_-_96px)] w-full justify-center items-center">
        <LoadingSpinner />
    </div>
{:else}
    <DrawerContainer {pageOverflowHidden}>
        <svelte:fragment slot="page">
            <ThreeColumnsLayout>
                <div slot="navbar">
                    {#if !hideNavbar && !$page_drawer && $page_navbar}
                        <Navbar isHiddenLogo={true} drawerOpenCallback={async () => { page_drawer.set(!$page_drawer) }} />
                    {/if}
                </div>
            
                <div slot="sidebar">
                    <ReaderSidebar />
                </div>
            
                <div class="flex flex-col w-screen lg:w-auto overflow-x-hidden justify-start items-start px-0 {$page_mobiletabs ? `pb-24` : ``} {`` || ``}">
                    {#if $page_mobiletabs}
                        <MobileTabs />
                    {/if}
                    {#if pageLoading}
                        <div class="flex flex-col h-[calc(100vh_-_96px)] w-full justify-center items-center">
                            <LoadingSpinner />
                        </div>
                    {:else}
                        <slot />
                    {/if}
                </div>
            </ThreeColumnsLayout>
        </svelte:fragment>
        <svelte:fragment slot="drawer">
            <DrawerNavigationLinks />
        </svelte:fragment>
    </DrawerContainer>
{/if}

