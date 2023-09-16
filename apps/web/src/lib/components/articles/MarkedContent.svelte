<script lang="ts">
    import CardContent from '$lib/components/events/content.svelte';
    import { NDKHighlight } from "@nostr-dev-kit/ndk";
    import type { NDKEventId, NDKTag } from '@nostr-dev-kit/ndk';
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
        let words = hContent.split(/ /);

        // Choose first N and last N words for the regex (N could be 2, 3, or whatever makes sense)
        const N = 3;
        const firstNWords = words.slice(0, N);
        const lastNWords = words.slice(-N);

        // Remove non-alphanumeric characters
        const sanitizeWord = (w: string) => w.replace(/[^a-zA-Z0-9]/g, '.*');
        const firstNWordsSanitized = firstNWords.map(sanitizeWord);
        const lastNWordsSanitized = lastNWords.map(sanitizeWord);

        // Create a regex pattern that matches the first and last N words with any characters in between
        const pattern = firstNWordsSanitized.join('[^]*?') + '[^]*?' + lastNWordsSanitized.join('[^]*?');

        // Create a RegExp object from the pattern
        const regex = new RegExp(pattern, 'is');

        console.log({htmlText, regex});

        // Wrap the matched text in <mark> tags
        return htmlText.replace(regex, (match) => `<mark id=${highlight.id} data-highlight-id="${highlight.id}">${match}</mark>`);
    }

    // let replacedHighlights: Record<string, boolean> = {};
    let markedContent: string = unmarkedContent;

    function markContent(highlight: NDKHighlight) {
        // if (highlight.id !== 'd40d961dfa58f99836d0b7a33cc5e0aadd50dea6dad118cfb281f5261e84342b') return;
        console.log(`markContent`, highlight.id);

        if (!markedContent) return;

        // remove from content breaklines and other control characters
        markedContent = markedContent.replace(/[\n\r\t]/g, ' ');

        if (!highlight.content) return; // ignore highlights without content
        if (highlight.content.length < 2) return; // ignore single character highlights
        // if (replacedHighlights[highlight.id!]) return;

        // check if highlight is in the content
        if (markedContent.includes(highlight.content)) {
            markedContent = markedContent.replace(highlight.content, `<mark id=${highlight.id} data-highlight-id="${highlight.id}">${highlight.content}</mark>`);
            // replacedHighlights[highlight.id!] = true;
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
                        // replacedHighlights[highlight.id!] = true;
                    } else {
                        console.log('could not find meaningful parts', parts);
                    }
                } else {
                    console.log('could not find meaningful parts', parts);
                }
            }
        }
    }

    const processedHighlightIds = new Set<NDKEventId>();

    const debouncedMarkContent = debounce(100, markContent);

    $: for (const highlight of $highlights) {
        if (processedHighlightIds.has(highlight.id!)) continue;
        processedHighlightIds.add(highlight.id!);

        debouncedMarkContent(highlight);
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
    {#if renderAsHtml || true}
        {@html markedContent}
    {:else}
        <CardContent
            note={markedContent??""}
            {tags}
            {addNewLines}
        />
    {/if}
</div>
