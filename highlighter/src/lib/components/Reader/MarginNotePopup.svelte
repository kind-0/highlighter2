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

    let isSmallScreen = false;
    let currentMode = "absolute"; // possible values: "absolute", "inserted"
    let myElement: HTMLElement | null = null;

    // Listen to window resize events
    window.addEventListener("resize", updatePosition);

    // Initialize based on initial window size
    $: isSmallScreen = true; //window.innerWidth < 1081;

    //console.log({isSmallScreen});

    function updatePosition() {
        // isSmallScreen = window.innerWidth < 1081;
        isSmallScreen = true
        if (isSmallScreen && referenceElement && myElement && currentMode !== "inserted") {
            referenceElement.insertAdjacentElement('afterend', myElement);
            currentMode = "inserted";
        } else if (!isSmallScreen && currentMode !== "absolute") {
            // Insert the element back to its original container, if you have its reference.
            // Otherwise, apply your absolute positioning logic here.
            positionElement();
            currentMode = "absolute";
        }
        console.log({isSmallScreen, currentMode});
    }

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
        updatePosition(); // Call the update function whenever the reactive statements are run
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
    let commentCount: number;
</script>

{#if verticalPosition}
    <div
        bind:this={myElement}
        class="{currentMode} {$$props.class || ``} left-1"
        style="top: {verticalPosition}px; z-index: 1;"
    >
        {#if $ownMarginNotes?.size === 0}
            <div class="flex flex-row gap-3 items-center group">
                <LinkToProfile {user}>
                    <Avatar {user} type="circle" size="small" />
                </LinkToProfile>

                <CommentsButton
                    event={highlightEvent}
                    bind:commentCount
                    class="
                        btn btn-neutral btn-sm p-1 !rounded-full px-3 font-light
                        {commentCount === 0 ? "opacity-0 group-hover:opacity-100" : ""}
                    "
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