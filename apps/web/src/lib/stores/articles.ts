import { NDKKind, NDKArticle, type NDKFilter } from "@nostr-dev-kit/ndk";
import type { NDKEventStore } from "@nostr-dev-kit/ndk-svelte";
import { get } from "svelte/store";
import { ndk } from "@kind0/ui-common";

const baseFilters: NDKFilter[] = [ { kinds: [NDKKind.Article as number], limit: 10 } ];

export const newArticles: NDKEventStore<NDKArticle> = get(ndk).storeSubscribe(
    baseFilters, {
        autoStart: true,
        closeOnEose: false,
        subId: "new-articles-store",
        unrefUnsubscribeTimeout: 5000,
    },
    NDKArticle
);

export function setNewArticlesFilters(extraFilter: NDKFilter = {}, extraFilters?: NDKFilter[]) {
    const f = [
        ...baseFilters,
    ].map((filter) => {
        return {
            ...filter,
            ...extraFilter
        };
    });

    if (extraFilters) {
        f.push(...extraFilters);
    }

    newArticles.changeFilters(f);
}
