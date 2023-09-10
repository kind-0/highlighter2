import { ndk } from "@kind0/lib-svelte-kit";
import { NDKAppHandlerEvent } from "@nostr-dev-kit/ndk";
import { derived, get as getStore } from "svelte/store";

const $ndk = getStore(ndk);

export const appHandlers = $ndk.storeSubscribe<NDKAppHandlerEvent>({
    kinds: [31990 as number],
    "#k": [ 65008 ].map(j => j.toString())
}, { closeOnEose: true, subId: 'app-handlers' },
NDKAppHandlerEvent
);

export const contentDiscoveryApps = derived(appHandlers, ($appHandlers) => {
    return $appHandlers;
});