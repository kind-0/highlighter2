<script lang="ts">
import { userDVMRequests, userFollowHashtags, userLists } from './../lib/stores/session.ts';
import { onMount, setContext } from 'svelte';
import { login } from '$lib/utils/login';
import '../app.postcss';
import { Modals, closeModal } from 'svelte-modals'
import { fade } from 'svelte/transition'
// import { pwaInfo } from 'virtual:pwa-info';
import "@fontsource/lora";
import Loading from '$lib/components/Loading.svelte';
import { page } from '$app/stores';
import { goto } from '$app/navigation';
import { user as uiCommonUser, userLabels as uiCommonUserLabels } from '@kind0/ui-common';
import { appHandlers } from '$stores/nip89';

// NOOP To make sure the import is not tree-shaken
$appHandlers;

import { user, userLabels, prepareSession, loadingScreen, userFollows, networkFollows, userAppHandlers, userDVMResults } from '$stores/session';
import { bunkerNDK, ndk } from '@kind0/lib-svelte-kit';

$: webManifestLink = ''

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
let finishLoading = false;
$loadingScreen = true;
$loadingScreen = false;

if ($page.url.pathname === '/') {
goto('/reader');
} else if ($page.url.pathname !== '/reader') {
finishLoading = true;
}

prepareSession().then(() => {
if (finishLoading) $loadingScreen = false;
})
} else {
prepareSession();
}
}

$: if (!$uiCommonUser && $user) {
$uiCommonUser = $user;
}

$: $uiCommonUserLabels = $userLabels;

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
{/if}

{#if mounted}
<div transition:fade>
<slot />
</div>
{/if}

<!-- <div class="sticky bottom-0 left-0 right-0 text-base-100-content">
<pre>
user = {!!$user}
userFollows = {$userFollows?.size}
userAppHandlers = {$userAppHandlers?.size}
appHandlers = {$appHandlers?.length}
userDVMResults = {$userDVMResults?.size}
userDVMRequests = {$userDVMRequests?.size}
userLists = {$userLists?.size}
userFollowHashtags = {$userFollowHashtags?.length}
networkFollows = {$networkFollows?.size}
<hr>
mounted = {mounted}
$page.url.pathname = {$page.url.pathname}
</pre>
</div> -->

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
