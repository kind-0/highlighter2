<script lang="ts">
    import { goto } from "$app/navigation";
    import { NDKEvent, NDKArticle } from "@nostr-dev-kit/ndk";
    import { onDestroy, onMount } from "svelte";
    import { EventCard, ndk } from "@kind0/ui-common";
    import { Textarea } from '@kind0/ui-common';
    import { addLongForm, removeLongForm, isSaved as isLongFormSaved } from "$lib/stores/long-form";
    import type { NDKList } from "@nostr-dev-kit/ndk";
    import Toolbar from "./Toolbar.svelte";
    import { user } from "$stores/session";
    import { EventContent } from "@nostr-dev-kit/ndk-svelte-components";
    import Article from "$components/Article.svelte";
    import ArticleContentCard from "$components/ContentCards/ArticleContentCard.svelte";

    export let event: NDKArticle;

    let title: string = event?.title ?? "Untitled";

    let body: string = event?.content || "";
    let visibility = event?.kind === 30023 ? 'Public' : 'Secret';
    let showInsert = true;

    let previewMode = false;

    let selectedItem: NDKList;

    onMount(() => {
        title = event.title || "";
    });

    onDestroy(() => {
        if (!isLongFormSaved(event)) {
            if (event.content.length < 10)
                removeLongForm(event);
        }
    });

    $: event.kind = visibility === 'Public' ? 30023 : 31023;

    async function save() {
        event.title = title;
        event.content = body;
        event.published_at = undefined;

        event.created_at = Math.floor(Date.now() / 1000);

        if (visibility === 'Secret') {
            event.kind = 31023;
            event.title = await $ndk.signer!.encrypt($user!, title);

            await event.encrypt($user!);
        }

        await event.sign();
        await event.publish();

        goto(`/notes`);
    }

    let bodyEl;

    function onTitleKeyDown(e: KeyboardEvent) {
        if (e.key === "Enter") {
            e.preventDefault();
            e.stopPropagation();

            // move focus to body
            bodyEl.focus = true;
        }
    }

    function onTitleKeyUp() {
        event.title = title;
        addLongForm(event, true);
    }

    function onBodyChange() {
        event.content = body;
        body = body
        addLongForm(event, true);
    }
</script>

<div class="flex flex-row gap-8 overflow-y-auto h-full min-h-[80vh]">
    <div
        class="flex flex-col h-full w-full gap-4"
    >
        <div class="card card-compact h-full">
            <div class="flex-row items-center justify-between hidden lg:flex z-50 w-full py-2 px-4 pt-2">
                <Toolbar
                    bind:title
                    bind:event
                    bind:previewMode={previewMode}
                    on:save={save}
                    on:keydown={onTitleKeyDown}
                    on:keyup={onTitleKeyUp}
                    on:change={onTitleKeyUp}
                />
            </div>
            <div class="divider my-0"></div>
            <div class="card-body">
                {#if !previewMode}
                    <Textarea
                        bind:this={bodyEl}
                        class="w-full border-0
                            flex-grow
                            h-full
                            bg-transparent
                            focus:ring-0 focus:border-0
                            focus:!border-none
                            placeholder-base-300-contrast
                            text-base-300-content
                            focus:outline-none
                            px-0
                        "
                        placeholder="Start writing..."
                        bind:value={body}
                        on:change={onBodyChange}
                        on:keyup={onBodyChange}
                    />
                {:else}
                    <Article>
                        <EventContent
                            ndk={$ndk}
                            {event}
                        />
                    </Article>
                {/if}
            </div>
        </div>
    </div>
</div>