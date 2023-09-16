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
        let paragraphs = hContent.split(/\n/);

        // console.log({paragraphs});

        for (const paragraph of paragraphs) {
            if (paragraph.length === 0) continue;

            let words = paragraph.split(/[ ]+/)
                .filter(w => w.length > 0);

            // console.log({words})

            let regex: RegExp;

            // console.log(words.length, 'words');

            // Choose first N and last N words for the regex (N could be 2, 3, or whatever makes sense)
            if (words.length > 10) {
                const N = 5;
                const firstNWords = words.slice(0, N);
                const lastNWords = words.slice(-N);

                // Remove non-alphanumeric characters
                const sanitizeWord = (w: string) => w
                const firstNWordsSanitized = firstNWords.map(sanitizeWord);
                const lastNWordsSanitized = lastNWords.map(sanitizeWord);

                // Create a regex pattern that matches the first and last N words with any characters in between
                const pattern = firstNWordsSanitized.join(' ') + '[^]*?' + lastNWordsSanitized.join('[^]*?');

                // Create a RegExp object from the pattern
                regex = new RegExp(pattern, 's');
            } else {
                regex = new RegExp(words.join('( )+'));
            }

            // console.log({regex});

            // Wrap the matched text in <mark> tags
            htmlText = htmlText.replace(regex, (match) => {
                // console.log(`found a match using regexp`, {match});

                // if there is a </p> in the match, we need to split by <p> to find
                // all starting paragraphs and add a <mark>
                // if (match.match(/<\/p>/)) {
                //     console.log(`match contains paragraph breaks`);
                //     const parts = match.split(/(<\/p>)/);
                //         console.log({parts});
                //     return parts
                //         .map(part => `<mark id=${highlight.id} data-highlight-id="${highlight.id}">${part}</mark>`)
                //         .join('');
                // }

                return `<mark id=${highlight.id} data-highlight-id="${highlight.id}">${match}</mark> (${highlight.id.slice(0, 6)})`
            });

            // console.log({htmlText});
        }

        return htmlText;
    }

    // let replacedHighlights: Record<string, boolean> = {};
    let markedContent: string = unmarkedContent;

    function markContent(highlight: NDKHighlight) {
        // console.log(`markContent`, highlight.id, highlight.content);
        // if (highlight.id !== '99f7108c83e23f1ff9cbbb9d33cffab511aa862a74ca4ba84b375821e339a215') return;

        if (!markedContent) return;

        // remove from content breaklines and other control characters
        markedContent = markedContent.replace(/[\n\r\t]/g, ' ');

        if (!highlight.content) return; // ignore highlights without content
        if (highlight.content.length < 2) return; // ignore single character highlights
        // if (replacedHighlights[highlight.id!]) return;

        // check if highlight is in the content
        if (markedContent.includes(highlight.content)) {
            markedContent = markedContent.replace(highlight.content, `<mark id=${highlight.id} data-highlight-id="${highlight.id}">${highlight.content}</mark> (${highlight.id.slice(0, 6)})`);
            // replacedHighlights[highlight.id!] = true;
        } else {
            // highlight is not in the content, try to find it
            // console.log('could not find highlight 1', highlight.content, highlight.rawEvent());
            markedContent = markText(highlight, markedContent);
        }

        // check if highlight id is in the content
        if (!markedContent.includes(highlight.id!)) {
            // console.log('could not find highlight id 2', highlight.id, highlight.rawEvent());
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

        markContent(highlight);
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
