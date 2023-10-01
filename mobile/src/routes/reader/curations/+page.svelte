<script lang="ts">
    import TagContentCards from "$components/ContentCards/TagContentCards.svelte";
    import Section from "$components/Section.svelte";
import { ndk } from "@kind0/ui-common";
    import { NDKList } from "@nostr-dev-kit/ndk";

    const curations = $ndk.storeSubscribe({
        kinds: [30001],
        "#c": ["curation"]
    }, undefined, NDKList)
</script>

{$curations.length}

{#each $curations as curation (curation.id)}
    <Section
        title={curation.tagValue("title")??"Untitled"}
    >

        <TagContentCards tags={curation.items} />
    </Section>
{/each}