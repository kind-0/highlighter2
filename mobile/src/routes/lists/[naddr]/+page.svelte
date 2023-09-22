<script lang="ts">
    import { idFromNaddr } from "$lib/utils";
    import List from "./list.svelte";
    import { userLists } from "$stores/session";
    import { page } from "$app/stores";
    import { derived, type Readable } from "svelte/store";
    import { ndk } from "@kind0/ui-common";
    import { MainWithRightSidebar } from "@kind0/ui-common";
    import type { NDKList } from "@nostr-dev-kit/ndk";

    let naddr: string;
    let prevNaddr: string;

    $: naddr = $page.params.naddr;

    let list: Readable<NDKList | undefined>;

    $: if (naddr !== prevNaddr || !list) {
        prevNaddr = naddr;

        const id = idFromNaddr(naddr);

        list = derived(userLists, ($userLists) => {
            const list = $userLists.get(id);
            if (!list) return undefined;

            // de-duplicate list items
            const tags = [...new Set(list.tags)];
            list.tags = tags;
            list.ndk = $ndk;

            return list;
        });
    }
</script>

<MainWithRightSidebar>
    {#key naddr}
        {#if $list}
            <List list={$list} />
        {/if}
    {/key}
</MainWithRightSidebar>