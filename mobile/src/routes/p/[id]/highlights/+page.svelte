<script lang="ts">
    import { page } from "$app/stores";
    import HighlightList from "$components/HighlightList.svelte";
    import Section from "$components/Section.svelte";
    import { NDKKind, NDKUser, type NDKTag } from "@nostr-dev-kit/ndk";
    import { ThreeColumnsLayout, ndk } from "@kind0/ui-common";
    import { NDKHighlight } from "@nostr-dev-kit/ndk";
    import { onDestroy, onMount } from "svelte";
    import type { NDKEventStore } from "@nostr-dev-kit/ndk-svelte";
    import Navbar from "$components/Navbar/Navbar.svelte";
    import Sidebar from "../Sidebar/Sidebar.svelte";
    import { derived, type Readable } from "svelte/store";
    import TagContentCards from "$components/ContentCards/TagContentCards.svelte";

    const { npub } = $page.data;

    let user: NDKUser;
    let highlights: NDKEventStore<NDKHighlight> | undefined;
    let articleTags: Readable<Set<NDKTag>>;

    onMount(() => {
        user = $ndk.getUser({npub});

        highlights = $ndk.storeSubscribe({
            kinds: [NDKKind.Highlight as number],
            authors: [user.hexpubkey]
        }, undefined, NDKHighlight);

        articleTags = derived(highlights, $highlights => {
            const tags = new Set<NDKTag>();

            $highlights?.forEach((h: NDKHighlight) => {
                const tag = h.getArticleTag();
                if (tag) tags.add(tag);
            })

            return tags;
        })
    });

    onDestroy(() => {
        if (highlights) highlights.unsubscribe();
    });

    let expanded = false;
</script>

{#if $articleTags}
    <Section
        title="Recently Highlighted"
        on:click={() => { expanded = true; }}
        {expanded}
    >
        <TagContentCards tags={Array.from($articleTags)} />
    </Section>
{/if}

<HighlightList items={$highlights} />