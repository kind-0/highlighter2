<script lang="ts">
    import { NDKPrivateKeySigner } from '@nostr-dev-kit/ndk';
    import { ndk } from "@kind0/lib-svelte-kit";
    import { user } from '$stores/session';
    import { setupPlaceholderProfile } from './LoginModal/placeholder-profile';
    import KeyIcon from '$lib/icons/Key.svelte';
    import AttentionButton from '$lib/components/buttons/AttentionButton.svelte';

    async function loginAsGuest() {
        const pk = NDKPrivateKeySigner.generate();
        $ndk.signer = pk;
        $user = await $ndk.signer.user();

        localStorage.setItem('nostr-key-method', 'pk');
        localStorage.setItem('nostr-key', pk.privateKey!);
        localStorage.setItem('nostr-target-npub', $user.npub);

        setupPlaceholderProfile();
    }
</script>

<AttentionButton on:click={loginAsGuest}>
    <div slot="btn-content" class="flex items-center gap-2">
        <KeyIcon />
        <span >Continue as Guest</span>
    </div>
</AttentionButton>
