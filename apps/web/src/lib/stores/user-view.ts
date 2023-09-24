import { ndk } from "@kind0/ui-common";
import { NDKKind, type NDKEvent, type NDKUser } from "@nostr-dev-kit/ndk";
import type { NDKEventStore } from "@nostr-dev-kit/ndk-svelte";
import { writable, get as getStore } from "svelte/store";

export let userSubscription: NDKEventStore<NDKEvent>;
export const userHighlights = writable(new Set<NDKEvent>);

export function startUserView(user: NDKUser) {
    const $ndk = getStore(ndk);

    if (userSubscription) {
        userSubscription.unsubscribe();
    }

    userSubscription = $ndk.storeSubscribe([
        {
            kinds: [ NDKKind.Highlight, NDKKind.Article ],
            authors: [user.hexpubkey]
        },
        {
            kinds: [ NDKKind.Zap ],
            "#p": [ user.hexpubkey ]
        }
    ], {
        subId: 'user-view'
    });
}