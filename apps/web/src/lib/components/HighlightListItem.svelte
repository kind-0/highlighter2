<!--
    This component is used to display a highlight in a list of highlights.

    When a highlight event is loaded, it will attempt to load margin notes
    of this highlights to render them as well.
-->
<script lang="ts">
    import HighlightCard from '$lib/components/highlights/HighlightCard.svelte';

    import{ Avatar } from "@kind0/ui-common";

    import NoteCard from '$lib/components/notes/card.svelte';
    import type { NDKHighlight } from "@nostr-dev-kit/ndk";
    import type { NDKEvent } from '@nostr-dev-kit/ndk';
    import type { NDKEventStore } from '@nostr-dev-kit/ndk-svelte';
    import { ndk } from "@kind0/ui-common";
    import { MarginNoteCard } from '@highlighter/svelte-kit-lib';

    export let highlight: NDKHighlight;
    export let skipTitle: boolean = false;
    export let skipButtons: boolean = false;
    export let disableClick: boolean = false;
    export let collapsedQuotes: boolean = true;

    let articlePromise = highlight.getArticle();

    /**
     * When the tagged event allows (e.g. kind:1) expand the context
     * to be the full tagged event instead of the context embedded in the highlight.
     */
    export let expandedContext: boolean = true;

    let quotes: NDKEventStore<NDKEvent>;
    let quotePubkeys: string[] = [];

    // Set the quote pubkeys
    $: if ($quotes && $quotes.length > 0 && $quotes.length != quotePubkeys.length) {
        quotePubkeys = $quotes.map((q: NDKEvent) => q.pubkey);
    }

    quotes = $ndk.storeSubscribe(
        { kinds: [1], '#q': [highlight.id] },
        { closeOnEose: true, groupableDelay: 500, subId: "highlight-quotes" }
    );

    function shouldDisplayQuote(highlight: NDKHighlight, quotes: NDKEvent[]) {
        if (!$quotes || $quotes.length === 0) {
            return true;
        }

        return false;
    }
</script>

{#await articlePromise then article}
    <div class="flex flex-col overflow-hidden gap-8 {$$props.class}">
        {#if shouldDisplayQuote(highlight, $quotes||[])}
            <HighlightCard
                class={$$props.itemClass}
                {highlight}
                {article}
                {expandedContext}
                {skipButtons}
                {skipTitle}
                {disableClick}
            />
            {#if ($quotes||[]).length > 0}
                <div class="ml-6 flex flex-col gap-6 quote-card">
                    {#each ($quotes||[]) as quote}
                        <div class="text-lg">
                            <NoteCard event={quote} />
                        </div>
                    {/each}
                </div>
            {/if}
        {:else}
            {#each ($quotes||[]) as quote}
                <div class="text-lg">
                    <MarginNoteCard event={quote} />
                </div>
            {/each}
        {/if}
    </div>
{/await}