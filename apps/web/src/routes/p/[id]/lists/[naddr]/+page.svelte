<script lang="ts">
    import { page } from "$app/stores";
    import MainWithRightSidebar from "$lib/layouts/MainWithRightSidebar.svelte";
    import { PageTitle, ndk } from "@kind0/ui-common";
    import { NDKList } from "@nostr-dev-kit/ndk";
    import Tags from '../../../../lists/[naddr]/tags.svelte';
    import ListsWithSimilarItems from "$lib/components/lists/ListsWithSimilarItems.svelte";
    import TagContentCard from "$components/ContentCards/TagContentCard.svelte";

    const { naddr } = $page.params;

    let list: NDKList | undefined;

    const fetch = new Promise<NDKList>((resolve, reject) => {
        $ndk.fetchEvent(naddr).then((event) => {
            if (event) {
                list = NDKList.from(event);
                resolve(list);
            } else {
                reject("Unable to find list")
            }
        });
    });
</script>

{#await fetch then list}
    <PageTitle title={list.title} subtitle={list.description} />

    {#each list.items.slice(0, 50) as tag}
        <TagContentCard {tag} />

    {/each}
{/await}
