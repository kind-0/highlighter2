<script lang="ts">
    import type { NDKEvent, NDKHighlight } from "@nostr-dev-kit/ndk";
    import { ndk } from "@kind0/ui-common";
    import { fetchQuotedHighlight, removeQuotedEvent } from "../../Reader/utils";
    import { EventCard } from "@kind0/ui-common";
    import HighlightContent from "../Highlight/HighlightContent.svelte";
    import { EventContent } from "@nostr-dev-kit/ndk-svelte-components";
    import HighlightCardHeader from "../Highlight/HighlightCardHeader.svelte";
    import linkToArticle from "../Highlight/link-to-article";

    /**
     * Event to render
     */
    export let event: NDKEvent;

    export let skipTitle = false;
    export let skipHighlight = false;

    let highlight: NDKHighlight | null;

    fetchQuotedHighlight(event).then(h => highlight = h)
</script>

{#if highlight}
    <EventCard
        {event}
        authorAction="margin note by"
        skipHeader={skipTitle}
        class={$$props.class}
        on:mouseenter
        on:mouseleave
    >
        <div slot="header">
            {#if !skipTitle}
                <HighlightCardHeader {highlight} />
            {/if}
        </div>

        <a href={linkToArticle(highlight)} class="
            h-full flex flex-col gap-2
            overflow-auto
            {$$props.class}
        ">
            {#if !skipHighlight}
                <div class="text-sm">
                    <HighlightContent
                        {highlight}
                    />
                </div>
            {/if}

            <div class="text-base-100-content md:font-serif leading-[1.8rem]">
                <EventContent
                    ndk={$ndk}
                    {event}
                    content={removeQuotedEvent(event)}
                />
            </div>
        </a>
    </EventCard>
{/if}