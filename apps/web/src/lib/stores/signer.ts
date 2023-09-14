import { findEphemeralSigner } from '$lib/signers/ephemeral';
import { NDKPrivateKeySigner, type NDKSigner, type NDKUser } from '@nostr-dev-kit/ndk';
import { writable, get as getStore, derived } from 'svelte/store';
import { ndk as ndkStore } from '@kind0/ui-common';
import { user as userStore } from '$stores/session';
import type { NDKList } from "@nostr-dev-kit/ndk";

export type SignerStoreItem = {
    signer: NDKPrivateKeySigner;
    user: NDKUser;
    saved: boolean;
    name?: string;
    id: string;
};

type SignerItems = Map<string, SignerStoreItem>;

export const signers = writable<SignerItems>(new Map());
export const npubSigners = derived(signers, ($signers) => {
    const npubs = new Map<string, NDKSigner>();

    for (const entry of $signers) {
        const { user, signer } = entry[1];

        npubs.set(user.npub, signer);
    }

    return npubs;
});

async function getDelegatedSignerName(list: NDKList) {
    let name = '';
    const $user: NDKUser = getStore(userStore)!;

    if (!$user?.profile) {
        $user.ndk = getStore(ndkStore);
        await $user?.fetchProfile();
    }

    if ($user?.profile?.name) {
        name = $user.profile.displayName + `'s `;
    }

    return name + list.name;
}

export async function getSigner(list: NDKList): Promise<SignerStoreItem> {
    const store = getStore(signers);
    const id = list.encode();
    let item = store.get(id);

    if (item) return item;

    const ndk = getStore(ndkStore);
    let signer = await findEphemeralSigner(ndk, ndk.signer!, {
        associatedEventNip19: list.encode(),
    });

    if (signer) {
        console.log(`found a signer for list ${list.name}`);
        item = {
            signer: signer!,
            user: await signer.user(),
            saved: true,
            id,
        };
    } else {
        signer = NDKPrivateKeySigner.generate();
        item = {
            signer,
            user: await signer.user(),
            saved: false,
            name: await getDelegatedSignerName(list),
            id,
        };
    }
    item.user.ndk = ndk;

    store.set(id, item);

    return item;
}
