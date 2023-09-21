<!--

# About

This component is used to display margin
notes in the sidebar on a reader component.

Each <MarginNotePopup> component represents a single margin note.

-->
<script lang="ts">
    import type { NDKEvent, NDKUser } from "@nostr-dev-kit/ndk";
    import { Avatar, CommentsButton, LinkToProfile, ThreadView } from "@kind0/ui-common";
    import ReaderMarginNoteCard from "./ReaderMarginNoteCard.svelte";
    import type { Readable } from 'svelte/store';
    import { derived } from 'svelte/store';

    export let highlightEvent: NDKEvent;
    export let user: NDKUser;
    export let marginNotes: Readable<NDKEvent[]>;
    export let verticalPosition: number | undefined = undefined;
    export let popupPositions: Readable<Set<number>>;

    const markId = highlightEvent.id;

    const ownMarginNotes = derived(marginNotes, $marginNotes => {
            const ownMarginNotes = new Set<NDKEvent>();

            for (const marginNote of $marginNotes) {
                if (marginNote.tagValue("q") === markId) {
                    ownMarginNotes.add(marginNote);
                }
            }

            return ownMarginNotes;
        }
    );

    let referenceElement: HTMLElement | null = null;

    function positionElement() {
        referenceElement = document.getElementById(markId);
        let containerElement = document.getElementById('sidebarContainer');

        const containerElementRect = containerElement?.getBoundingClientRect()
        const rect = referenceElement?.getBoundingClientRect()

        if (!rect) {
            setTimeout(positionElement, 500);
        }

        // get the height of the reference element
        if (rect && containerElementRect) {
            verticalPosition = rect.y - containerElementRect.y;
        }
    }

    function adjustPositionIfOccupied() {
        popupPositions.update((positions) => {
            while (positions.has(verticalPosition)) {
                verticalPosition += 40;
            }
            positions.add(verticalPosition);
            return positions;
        });
    }

    $: {
        positionElement();
        adjustPositionIfOccupied();
    }

    function hover(hovering: boolean) {
        // mark the reference element as active
        if (hovering) {
            referenceElement?.classList.add('active');
        } else {
            referenceElement?.classList.remove('active');
        }
    }

    let open = false;
</script>

{#if verticalPosition}
    <div
        class="absolute {$$props.class}"
        style="top: {verticalPosition}px; z-index: 1; left: 1"
    >
        {#if $ownMarginNotes?.size === 0}
            <div class="flex flex-row gap-3 items-center group">
                <LinkToProfile {user}>
                    <Avatar {user} type="circle" size="small" />
                </LinkToProfile>

                <CommentsButton
                    event={highlightEvent}
                    class="btn btn-neutral btn-sm p-1 !rounded-full px-3 font-light opacity-0 group-hover:opacity-100"
                    emit={true}
                    on:click={() => { open = !open }}
                />
            </div>
            {#if open}
                <ThreadView event={highlightEvent} skipEvent={true} />
            {/if}
        {:else}
            {#each $ownMarginNotes as marginNote}
                <div
                    on:mouseenter={() => hover(true)}
                    on:mouseleave={() => hover(false)}
                >
                    <ReaderMarginNoteCard
                        event={marginNote}
                        skipHighlight={true}
                        class="cursor-pointer"
                    />
                </div>
            {/each}
        {/if}

    </div>
{/if}