<script lang="ts">
    import { user } from '$stores/session';
    import LoginDropdown from '$lib/ndk-svelte-components/LoginDropdown.svelte';
    import UserDropdown from './UserDropdown.svelte';
</script>

{#if $user}
    <UserDropdown />
{:else}
    <LoginDropdown />
{/if}
