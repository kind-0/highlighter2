<!--

# About

This component is used to display margin
notes in the sidebar on a reader component.

Each <MarginNotePopup> component represents a single margin note.

-->
<script lang="ts">
    import type { NDKEvent, NDKUser } from "@nostr-dev-kit/ndk";
    import { AvatarWithName } from "@kind0/ui-common";
    import ReaderMarginNoteCard from "./ReaderMarginNoteCard.svelte";
    import type { Readable } from 'svelte/store';
    import { derived } from 'svelte/store';

    export let markId = '';
    export let user: NDKUser;
    export let marginNotes: Readable<NDKEvent[]>;
    export let verticalPosition: number | undefined = undefined;

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

    $: positionElement();

    function hover(hovering: boolean) {
        // mark the reference element as active
        if (hovering) {
            referenceElement?.classList.add('active');
        } else {
            referenceElement?.classList.remove('active');
        }
    }
</script>

{#if verticalPosition}
    <div
        class="absolute {$$props.class}"
        style="top: {verticalPosition}px; z-index: 1; left: 1"
    >
        <div class="card card-compact bg-base-300 hidden">
            <div class="card-body text-xs">
                <AvatarWithName pubkey={user.hexpubkey} />
                highlighted by
            </div>
        </div>

        {#if $ownMarginNotes?.size > 0}
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