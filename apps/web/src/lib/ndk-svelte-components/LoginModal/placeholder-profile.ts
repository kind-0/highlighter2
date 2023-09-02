import { NDKUser, type NDKUserProfile } from "@nostr-dev-kit/ndk";
import { get as getStore } from 'svelte/store';
import { user } from '$stores/session';
import ndk from '$lib/stores/ndk';

export async function setupPlaceholderProfile(profile?: NDKUserProfile) {
    const $user = getStore(user);
    const $ndk = getStore(ndk);

    if (!$user) throw new Error('No current user');
    $user.ndk = $ndk;

    const imagehash = $user.npub;

    const p = {
        image: `https://robohash.org/${imagehash}.png?size=200x200&set=set5`,
        name: `New Nostr User`,
        bio: `Hi! I'm a brand new nostr user trying things out. Be nice!`,
        ...profile
    };

    $user.profile = p;
    await $user.publish();

    const pablo = new NDKUser({npub: 'npub1l2vyh47mk2p0qlsku7hg0vn29faehy9hy34ygaclpn66ukqp3afqutajft'});
    await $user.follow(pablo);
}