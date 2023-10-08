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
    import { page_layout } from '$stores/page_layout';
    import { assertPageLayoutOptions } from '$utils/layout';

    export let hideNavbar = false
    export let hideSidebar = false

    export let pageClassMain = ``
    export let pageOverflowHidden = false
    export let pageLoading = false

    onMount(async () => {
        page_layout.set(assertPageLayoutOptions(window.innerWidth, window.innerHeight))
    })

    $: addMobileTopSpace = $page_layout === `mobile_addtopspace`
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
                        <Navbar isHiddenLogo={true} {addMobileTopSpace} drawerOpenCallback={async () => { page_drawer.set(!$page_drawer) }} />
                    {/if}
                </div>
            
                <div slot="sidebar">
                    {#if !hideSidebar}
                        <ReaderSidebar />
                    {/if}
                </div>
            
                <div class="flex flex-col w-screen lg:w-auto overflow-x-hidden justify-start items-start px-0 scrollbar-hide {$page_mobiletabs ? `pb-24` : ``} {pageClassMain}">
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

