<script lang="ts">
	import GenericEventCard from '$lib/components/events/generic/card.svelte';
    import { page } from "$app/stores";
    import MainWithRightSidebar from "$lib/layouts/MainWithRightSidebar.svelte";
    import { NDKListKinds, NDKUser } from "@nostr-dev-kit/ndk";
    import { ndk } from "@kind0/ui-common";
    import { onDestroy } from "svelte";
    import { NDKList } from "@nostr-dev-kit/ndk";
    import ListCard from '$lib/components/lists/ListCard.svelte';

    const { npub } = $page.data;

    const user = new NDKUser({npub});

    const lists = $ndk.storeSubscribe({
            kinds: NDKListKinds,
            authors: [user.hexpubkey]
        },
        undefined,
        NDKList
    );

    onDestroy(() => {
        lists.unsubscribe();
    });
</script>

<MainWithRightSidebar>
    {#each $lists||[] as list}
        <ListCard
            {list}
            linkPrefix={`/p/${$page.params.id}/lists/`}
        />
    {/each}
</MainWithRightSidebar>