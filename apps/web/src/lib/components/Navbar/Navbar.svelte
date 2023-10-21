<script lang="ts">
    import CurrentUser from '$lib/components/CurrentUser.svelte';
    import FullLogo from '$lib/icons/FullLogo.svelte';
    import RelaysButton from '$lib/components/RelaysButton.svelte';
    import SearchInput from './SearchInput.svelte';
    import Logo from '$lib/icons/Logo.svelte';
    import {AtlasNotesLogo, pageDrawerToggle} from '@kind0/ui-common';
    import { user } from '$stores/session';
    import { page } from '$app/stores';
    import { page_layout } from '$stores/page_layout';

    export let isHiddenSidebar = false;
    export let isHiddenDrawerBtn = false;
    export let isHiddenLogo = false;
    export let mainComponent: any | undefined = undefined;
    export let logoLink = `/`;

    let addMobileTopSpace = false;

    $: addMobileTopSpace = $page_layout === `mobile_addtopspace`;

    let homeLink = '/';
    let navbarOpened = false;

    $: homeLink = $user ? `/reader` : '/';

    let currentRoute: string;
    let logoToUse: any = FullLogo;

    $: currentRoute = $page.url.pathname;
    $: if (
            currentRoute.startsWith('/lists') ||
            currentRoute.startsWith('/notes')
        ) {
        logoToUse = AtlasNotesLogo;
    } else {
        logoToUse = FullLogo;
    }

    function toggleDrawer() {
        $pageDrawerToggle = !$pageDrawerToggle;
    }
</script>

<nav class="flex flex-row gap-4 sticky top-0 py-4 w-full {addMobileTopSpace ? `max-lg:pt-12 mb-8` : `max-lg:pt-6`} px-4 max-lg:px-6 bg-base-100 backdrop-blur-sm justify-center">
        <div class="
            {navbarOpened ? 'hidden lg:flex' : 'flex'}
            flex-row items-center gap-4 navbar-start
            w-auto lg:w-sidebar
        ">
            <div class="flex-none {!isHiddenSidebar ? 'lg:hidden' : ''}">
                <label for="left-drawer" class="btn btn-square btn-ghost {isHiddenDrawerBtn ? 'hidden' : ''}">
                    <button on:click={toggleDrawer}>
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="inline-block w-6 h-6 stroke-current"
                            ><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" /></svg
                        >
                    </button>
                </label>
            </div>

            {#if !isHiddenLogo}
                <a href={logoLink || homeLink} class="md:w-full">
                    <div class="flex flex-shrink-0 items-center">
                        <div class="w-48 hidden md:block">
                            <svelte:component this={logoToUse} />
                        </div>
                    </div>
                    <div class="w-full flex justify-center">
                        <div class="md:hidden"><Logo /></div>
                    </div>
                </a>
            {/if}
        </div>

        <div class="
            navbar-center transition-all duration-100 ease-in-out
            flex-grow lg:flex-grow-0 lg:!w-main
            {navbarOpened ? 'w-full lg:w-[700px]' : ''}
        ">
            <div class="hidden sm:block">
                {#if !mainComponent}
                    <SearchInput bind:hasFocus={navbarOpened} />
                {:else}
                    <svelte:component this={mainComponent} />
                {/if}
            </div>
        </div>

        <div class="
            navbar-end
            w-auto lg:w-sidebar
            {navbarOpened ? 'hidden lg:flex' : 'flex'}
        ">
            <div class="flex items-center md:order-2 gap-4">
                <RelaysButton iconOnly={true} />
                <CurrentUser />
            </div>
        </div>
</nav>