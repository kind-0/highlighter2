<script lang="ts">
    import CurrentUser from '$lib/components/CurrentUser.svelte';
    import FullLogo from '$lib/icons/FullLogo.svelte';
    import RelaysButton from '$lib/components/RelaysButton.svelte';
    import SearchInput from './SearchInput.svelte';
    import Logo from '$lib/icons/Logo.svelte';
    import {AtlasNotesLogo} from '@kind0/ui-common';
    import { user } from '$stores/session';
    import { page } from '$app/stores';

    export let isHiddenSidebar = false;
    export let isHiddenDrawerBtn = false;
    export let mainComponent: any | undefined = undefined;

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
</script>

<nav class="navbar bg-base-100 shrink-0 sticky top-0 z-20 max-lg:px-8 px-4 py-4 bg-base-100/80 backdrop-blur-sm justify-center gap-4">
    <div class="w-full gap-32">
        <div class="
            {navbarOpened ? 'hidden lg:flex' : 'flex'}
            flex-row items-center sm:gap-4 navbar-start
            w-sidebar
        ">
            <div class="flex-none {!isHiddenSidebar ? 'lg:hidden' : ''}">
                <label for="left-drawer" class="btn btn-square btn-ghost {isHiddenDrawerBtn ? 'hidden' : ''}">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="inline-block w-6 h-6 stroke-current"
                        ><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" /></svg
                    >
                </label>
            </div>

            <a href={homeLink} class="md:w-full">
                <div class="flex flex-shrink-0 items-center">
                    <div class="w-48 hidden sm:block">
                        <svelte:component this={logoToUse} />
                    </div>
                </div>
                <div class="w-full flex justify-center">
                    <div class="sm:hidden"><Logo /></div>
                </div>
            </a>
        </div>

        <div class="
            navbar-center transition-all duration-100 ease-in-out
            flex-grow md:w-main
            {navbarOpened ? 'w-full md:w-[700px]' : ''}
        ">
            <div class="hidden lg:block">
                {#if !mainComponent}
                    <SearchInput bind:hasFocus={navbarOpened} />
                {:else}
                    <svelte:component this={mainComponent} />
                {/if}
            </div>
        </div>

        <div class="
            navbar-end
            w-sidebar
            {navbarOpened ? 'hidden lg:flex' : 'flex'}
        ">
            <div class="flex items-center md:order-2 gap-4">
                <div class="hidden">
                    <RelaysButton iconOnly={true} />
                </div>
                <CurrentUser />
            </div>
        </div>
    </div>
</nav>