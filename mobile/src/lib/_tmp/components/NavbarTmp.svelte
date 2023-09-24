<script lang="ts">
    import { page } from "$app/stores";
    import CurrentUser from "$lib/components/CurrentUser.svelte";
    import SearchInput from "$lib/components/Navbar/SearchInput.svelte";
    import FullLogo from "$lib/icons/FullLogo.svelte";
    import Logo from "$lib/icons/Logo.svelte";
    import { user } from "$stores/session";
    import { AtlasNotesLogo } from "@kind0/ui-common";

    export let isHiddenSidebar = false;
    export let isHiddenDrawerBtn = false;
    export let mainComponent: any | undefined = undefined;

    let homeLink = "/";
    let navbarOpened = false;

    $: homeLink = $user ? `/reader` : "/";

    let currentRoute: string;
    let logoToUse: any = FullLogo;

    $: currentRoute = $page.url.pathname;
    $: if (currentRoute.startsWith("/lists") || currentRoute.startsWith("/notes")) {
        logoToUse = AtlasNotesLogo;
    } else {
        logoToUse = FullLogo;
    }
</script>

<nav class="sticky top-0 z-20 flex flex-row flex-wrap min-h-16 px-4 justify-start items-center bg-base-100/80 backdrop-blur-sm">
    <div class="flex flex-row basis-1/4 justify-between">
        <div class="flex basis-1/2 {!isHiddenSidebar ? 'lg:hidden' : ''}">
            <label
                for="left-drawer"
                class="btn btn-square btn-ghost {isHiddenDrawerBtn ? 'hidden' : ''}"
            >
                <svg
                    xmlns="http://www.w3.org/2000/svg"
                    fill="none"
                    viewBox="0 0 24 24"
                    class="inline-block w-6 h-6 stroke-current"
                >
                    <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M4 6h16M4 12h16M4 18h16"
                    />
                </svg>
            </label>
        </div>
        <div class="flex basis-1/2 justify-center">
            <a
                href={homeLink}
                class="flex h-full w-full items-center justify-center"
            >
                <div class="flex hidden sm:block">
                    <svelte:component this={logoToUse} />
                </div>
                <div class="flex sm:hidden">
                    <Logo />
                </div>
            </a>
        </div>
    </div>
    <div class="hidden lg:block flex flex-row basis-1/2">
        <div
            class="flex transition-all duration-100 ease-in-out
            {navbarOpened ? 'w-full' : ''}"
        >
            {#if !mainComponent}
                <SearchInput bind:hasFocus={navbarOpened} />
            {:else}
                <svelte:component this={mainComponent} />
            {/if}
        </div>
    </div>
    <div class="flex flex-row basis-auto flex-1 justify-end">
        <CurrentUser />
    </div>
</nav>
