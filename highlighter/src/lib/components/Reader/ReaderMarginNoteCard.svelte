<script lang="ts">
    import { NDKUser, type NDKEvent } from "@nostr-dev-kit/ndk";
    import { LinkToProfile, ndk, ThreadView } from "@kind0/ui-common";
    // import HighlightContent from "$lib/components/highlights/HighlightContent.svelte";
    import { SubtleButton, EventCard } from "@kind0/ui-common";
    import { removeQuotedEvent, fetchQuotedHighlight } from './utils';
    import type { NDKHighlight} from "@nostr-dev-kit/ndk";
    import { AvatarWithName, ReplyModal } from "@kind0/ui-common";
    import { onDestroy } from "svelte";
    import { openModal } from "svelte-modals";
    import { Avatar, Name, EventContent } from "@nostr-dev-kit/ndk-svelte-components";
    import type { NDKEventStore } from "@nostr-dev-kit/ndk-svelte";
    import ReplyView from "./ReplyView.svelte";

    /**
     * Event to render
     */
    export let event: NDKEvent;

    export let skipTitle = false;
    export let skipHighlight = false;

    let highlight: NDKHighlight | null;

    fetchQuotedHighlight(event).then(h => {
        highlight = h
    })

    let replies: NDKEventStore<NDKEvent> = $ndk.storeSubscribe({
        kinds: [1],
        "#e": [event.id]
    }, { closeOnEose: false, groupableDelay: 250 });

    onDestroy(() => {
        replies.unsubscribe();
    })

    function chooseUsersToDisplay(userIds: Set<string>, limit: number = 3) {
        return Array.from(userIds).slice(0, limit).map(id => {
            const user = new NDKUser({hexpubkey: id});
            user.ndk = $ndk;
            return user;
        });
    }

    let replyingUsersIds = new Set<string>();

    $: {
        $replies.forEach(r => {
            replyingUsersIds.add(r.pubkey);
        })

        replyingUsersIds = replyingUsersIds;
    }

    let replying = false;
    let open = false;
</script>

{#if highlight}
    <EventCard
        {event}
        authorAction="margin note by"
        skipHeader={skipTitle}
        class={$$props.class || ``}
        on:mouseenter
        on:mouseleave
        on:click
    >
        <div slot="header" class="text-base-100-content">
            <AvatarWithName pubkey={event.author.hexpubkey} />
        </div>

        {#if !skipHighlight}
            <div class="text-sm">
                <!-- <HighlightContent
                    {highlight}
                /> -->
            </div>
        {/if}

        <!-- svelte-ignore a11y-click-events-have-key-events -->
        <!-- svelte-ignore a11y-no-static-element-interactions -->
        <div class="
            text-base-100-content cursor-pointer
        ">
            <EventContent
                ndk={$ndk}
                {event}
                content={removeQuotedEvent(event)}
                tags={event.tags}
            />
        </div>

        {#if replying}
            <ReplyView
                class="w-full"
                event={event}
                on:published={() => replying = false}
                on:cancel={() => replying = false}
            />
        {/if}

        <div slot="footer" class="flex flex-row justify-between gap-8 {replying ? 'hidden' : ''}">
            <div class="flex flex-row items-center gap-2">
                {#if $replies?.length > 0}
                    <div class="flex -space-x-2 overflow-hidden">
                        {#each chooseUsersToDisplay(replyingUsersIds) as user}
                            <LinkToProfile {user}>
                                <Avatar {user} ndk={$ndk} class="inline-block h-7 w-7 rounded-full" />
                            </LinkToProfile>
                        {/each}
                    </div>

                    <button class="truncate text-xs" on:click={() => open = !open}>
                        <Name user={chooseUsersToDisplay(replyingUsersIds, 1)[0]} ndk={$ndk} />
                        {#if replyingUsersIds.size > 1}
                            <span>and {replyingUsersIds.size - 1} others</span>
                        {/if} commented
                    </button>
                {/if}
            </div>

            <div>
                <SubtleButton
                    on:click={() => { openModal(ReplyModal, { event }) }}
                >
                    Add your thoughts
                </SubtleButton>
            </div>
        </div>
    </EventCard>

    {#if open}
        <ThreadView {event} skipEvent={true} />
    {/if}
{/if}