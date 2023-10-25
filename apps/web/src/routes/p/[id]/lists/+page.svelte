<script lang="ts">
    import { page } from "$app/stores";
    import TagContentCards from "$components/ContentCards/TagContentCards.svelte";
    import HighlightListItem from "$components/HighlightListItem.svelte";
    import Section from "$components/Section.svelte";
    import Highlight from "$icons/Highlight.svelte";
    import { ndk } from "@kind0/ui-common";
    import { NDKHighlight, NDKKind, NDKList, NDKUser } from "@nostr-dev-kit/ndk";

    const { npub } = $page.data;

    const user = new NDKUser({npub});

    const curations = $ndk.storeSubscribe([
        {
            authors: [user.pubkey],
            kinds: [NDKKind.CategorizedBookmarkList],
            "#c": ["curation"]
        }
        , {
            authors: [user.pubkey],
            kinds: [NDKKind.CategorizedHighlightList as number],

        }
    ], undefined, NDKList)
</script>

{#each $curations as curation (curation.id)}
    {#if curation.items.length > 0}
        <Section
            title={curation.title??"Curation List"}
        >

            <TagContentCards tags={curation.items} />
        </Section>
        {#each curation.items as item}
            {#await $ndk.fetchEvent(item[1]) then event}
                {#if event && event.kind === NDKKind.Highlight}
                    <HighlightListItem highlight={NDKHighlight.from(event)} />
                {/if}
            {/await}
        {/each}
    {/if}
{/each}