import { get as getStore } from 'svelte/store';
import { user as userStore } from '$stores/session';
import {ndk} from "@kind0/lib-svelte-kit";
import type { NDKUser } from '@nostr-dev-kit/ndk';

export function logout(): void {
    const $ndk = getStore(ndk);
    $ndk.signer = undefined;
    userStore.set(null);
    localStorage.removeItem("userStore");
    localStorage.removeItem("user-follows");
    localStorage.removeItem("network-follows");
    localStorage.removeItem("network-follows-updated-t");
    localStorage.removeItem("currentUserNpub");
    localStorage.removeItem("nostr-target-npub");

    // explicitly prevent auto-login with NIP-07
    localStorage.setItem("nostr-key-method", "none");
}