<script lang="ts">
    import EventVisibility from "$lib/components/events/editor/EventVisibility.svelte";
    import type { NDKEvent } from "@nostr-dev-kit/ndk";
    import { createEventDispatcher } from "svelte";
    import ArticleTitle from "./ArticleTitle.svelte";

    const dispatch = createEventDispatcher();

    export let title: string;
    export let event: NDKEvent;
    export let previewMode: boolean;
</script>

<div class="flex flex-row items-center justify-between fixed md:static w-full bottom-0 px-4 pt-2">
    <ArticleTitle
        bind:title
        on:keydown
        on:keyup
        on:change
        class="px-0 text-base-100-content"
    />
    <!-- {#if !event.sig}
        <EventVisibility
            placement="top"
            class="whitespace-nowrap bg-base-300 border-none !rounded-full"
            bind:value={visibility}
        />
    {/if}
 -->
    <!-- <button class="btn bg-base-300 !rounded-full" on:click={() => { showInsert = !showInsert}}>
        Insert
    </button> -->

    <div class="join join-horizontal divide-x divide-base-100">
        <button class="btn border-0 btn-neutral join-item" on:click={() => previewMode = !previewMode}>
            Preview
        </button>

        <button
            class="btn border-0 btn-neutral join-item"
            on:click={() => {dispatch('save')}}
        >
            Save
        </button>
    </div>
</div>