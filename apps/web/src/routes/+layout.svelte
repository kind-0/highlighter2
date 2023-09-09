<script lang="ts">
    import { onMount, setContext } from 'svelte';
    import { login } from '$lib/utils/login';
    import '../app.postcss';
    import { Modals, closeModal } from 'svelte-modals'
    import { fade } from 'svelte/transition'
    import { pwaInfo } from 'virtual:pwa-info';
    import "@fontsource/lora";
    import Loading from '$lib/components/Loading.svelte';
    import { page } from '$app/stores';
    import { goto } from '$app/navigation';
    import { user as uiCommonUser, userLabels as uiCommonUserLabels } from '@kind0/ui-common';

    import { user, userLabels, prepareSession, loadingScreen, userFollows, networkFollows } from '$stores/session';
    import { bunkerNDK, ndk } from '@kind0/lib-svelte-kit';

    $: webManifestLink = pwaInfo ? pwaInfo.webManifest.linkTag : ''

    let sessionPreparationStarted = false;
    let mounted = false;

    onMount(async () => {
        try {
            $ndk.connect();
            login($ndk, $bunkerNDK).then((user) => {
                $user = user;
                $uiCommonUser = user!;
                console.log(`setting user2`);
            })
            mounted = true;
        } catch (e) {
            console.error(`layout error2`, e);
            mounted = true;
        }
    });

    $: if (mounted && !!$user && !sessionPreparationStarted) {
        sessionPreparationStarted = true;
        if ($userFollows.size === 0) {
            $loadingScreen = true;

            if ($page.url.pathname === '/') {
                goto('/reader');
            }

            prepareSession().then(() => {
                $loadingScreen = false;
            })
        } else {
            prepareSession();
        }
    }

    $: if (!$uiCommonUser && $user) {
        $uiCommonUser = $user;
    }

    $: $uiCommonUserLabels = $userLabels;

    // Probably wrong
    $: {
        console.log(`setting user 2`);
    }

    let shouldShowLoadingScreen = true;

    $: shouldShowLoadingScreen = $page.url.pathname !== '/';
</script>

<svelte:head>
    <title>Highlighter</title>
    {@html webManifestLink}
</svelte:head>

{#if $loadingScreen && shouldShowLoadingScreen}
    <div transition:fade>
        <Loading on:loaded={() => $loadingScreen = false } />
    </div>
{:else if mounted}
    <div transition:fade>
        <slot />
    </div>
{:else}
{/if}

<Modals>
    <div
        slot="backdrop"
        class="backdrop z-10 fixed"
        on:click={closeModal}
        transition:fade={{ duration: 100 }}></div>
</Modals>

<style>
    .backdrop {
        position: fixed;
        top: 0;
        bottom: 0;
        right: 0;
        backdrop-filter: blur(0.15rem);
        left: 0;
        background: rgba(0,0,0,0.50)
    }
</style>