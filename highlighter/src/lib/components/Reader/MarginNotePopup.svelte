<!--

# About

This component is used to display margin
notes in the sidebar on a reader component.

Each <MarginNotePopup> component represents a single margin note.

-->
<script lang="ts">
    import type { NDKEvent, NDKUser } from "@nostr-dev-kit/ndk";
    import { AvatarWithName } from "@kind0/ui-common";
    import MarginNoteCard from "./MarginNoteCard.svelte";
    import type { Readable } from 'svelte/store';
    import { derived } from 'svelte/store';

    export let markId = '';
    export let user: NDKUser;
    export let marginNotes: Readable<NDKEvent[]>;

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

    let verticalHeight: number | undefined = undefined;
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
        if (rect && containerElementRect)
            verticalHeight = rect.y - containerElementRect.y;
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

<!-- vertical = {verticalHeight}
markId = {markId}

{#if $marginNotes}
    marginNotes = {$marginNotes.length}
    ownMarginNotes = {$ownMarginNotes.size}
{/if} -->

{#if verticalHeight}
    <div
        class="md:absolute {$$props.class}"
        style="top: {verticalHeight}px; z-index: 999999; left: 1"
    >
        <div class="card card-compact bg-base-300 hidden">
            <div class="card-body text-xs">
                <AvatarWithName pubkey={user.hexpubkey} />
            </div>
        </div>

        {#if $ownMarginNotes?.size > 0}
            {#each $ownMarginNotes as marginNote}
                <div
                    on:mouseenter={() => hover(true)}
                    on:mouseleave={() => hover(false)}
                >
                    <MarginNoteCard
                        event={marginNote}
                        skipHighlight={true}
                        class="cursor-pointer"
                    />
                </div>
            {/each}
        {/if}

    </div>
{/if}