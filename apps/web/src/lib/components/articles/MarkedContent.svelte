<script lang="ts">
    import CardContent from '$lib/components/events/content.svelte';
    import { NDKHighlight } from "@nostr-dev-kit/ndk";
    import type { NDKTag } from '@nostr-dev-kit/ndk';
    import { createEventDispatcher } from "svelte";
    import type { Readable } from 'svelte/motion';
    import { debounce } from 'throttle-debounce';

    const dispatch = createEventDispatcher();

    export let content: string;
    export let highlights: Readable<NDKHighlight[]>;
    export let tags: NDKTag[];
    export let addNewLines: boolean;
    export let unmarkedContent: string;
    export let renderAsHtml = false;

    function markText(highlight: NDKHighlight, htmlText: string) {
        const hContent = highlight.content.trim();

        // Split the plain text into words
        let words = hContent.split(/ /);

        // remove from words non alphanumeric characters
        words = words.map(w => w.replace(/[^a-zA-Z0-9]/g, '.*'));

        // Create a regex pattern that matches the words with any characters in between
        let pattern = words.join('.*');

        // Create a RegExp object from the pattern
        let regex = new RegExp(pattern, 'i');

        // Wrap the matched text in <mark> tags
        return htmlText.replace(regex, (match) => `<mark id=${highlight.id} data-highlight-id="${highlight.id}">${match}</mark>`);
    }

    let replacedHighlights: Record<string, boolean> = {};
    let markedContent: string = unmarkedContent;

    function markContent() {
        markedHighlightCount = $highlights.length;
        markedContent = unmarkedContent;

        if (!markedContent) return;

        // remove from content breaklines and other control characters
        markedContent = markedContent.replace(/[\n\r\t]/g, ' ');

        for (const highlight of $highlights) {
            if (!highlight.content) continue; // ignore highlights without content
            if (highlight.content.length < 2) continue; // ignore single character highlights
            if (replacedHighlights[highlight.id!]) continue;

            // check if highlight is in the content
            if (markedContent.includes(highlight.content)) {
                markedContent = markedContent.replace(highlight.content, `<mark id=${highlight.id} data-highlight-id="${highlight.id}">${highlight.content}</mark>`);
                replacedHighlights[highlight.id!] = true;
            } else {
                // highlight is not in the content, try to find it
                console.log('could not find highlight 1', highlight.content, highlight.rawEvent());
                markedContent = markText(highlight, markedContent);
            }

            // check if highlight id is in the content
            if (!markedContent.includes(highlight.id!)) {
                console.log('could not find highlight id 2', highlight.id, highlight.rawEvent());
                const hContent = highlight.content.trim();

                if (hContent.includes('\n')) {
                    const parts = hContent.split('\n');
                    const firstMeaningfulPart = parts.find(p => p.length > 2);
                    const lastMeaningfulPart = parts.reverse().find(p => p.length > 2);

                    if (firstMeaningfulPart && lastMeaningfulPart) {
                        const firstPartIndex = markedContent.indexOf(firstMeaningfulPart);
                        const lastPartIndex = markedContent.lastIndexOf(lastMeaningfulPart);

                        if (firstPartIndex !== -1 && lastPartIndex !== -1) {
                            const before = markedContent.slice(0, firstPartIndex);
                            const after = markedContent.slice(lastPartIndex + lastMeaningfulPart.length);

                            markedContent = `${before}<mark id=${highlight.id} data-highlight-id="${highlight.id}">${hContent}</mark>${after}`;
                            replacedHighlights[highlight.id!] = true;
                        } else {
                            console.log('could not find meaningful parts', parts);
                        }
                    } else {
                        console.log('could not find meaningful parts', parts);
                    }
                }
            }
        }
    }

    let markedHighlightCount = 0;

    const debouncedMarkContent = debounce(100, markContent);

    $: if ($highlights.length !== markedHighlightCount) {
        console.log(`running markContent`);
        debouncedMarkContent();
    }

    function clickHandler(e: MouseEvent) {
        const target = e.target as HTMLElement;

        // if target is a mark with data-highlight-id emit an event
        if (target.dataset.highlightId) {
            const id = target.dataset.highlightId;
            const highlight = $highlights.find(h => h.id === id);

            if (highlight) {
                dispatch('highlight-clicked', highlight);
            }
        }
    }
</script>

<div on:click={clickHandler}>
    {#if renderAsHtml}
        {@html markedContent}
    {:else}
        <CardContent
            note={markedContent??""}
            {tags}
            {addNewLines}
        />
    {/if}
</div>
