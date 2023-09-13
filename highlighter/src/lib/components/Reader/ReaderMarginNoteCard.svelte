<script lang="ts">
    import { NDKUser, type NDKEvent } from "@nostr-dev-kit/ndk";
    import { ndk } from "@kind0/ui-common";
    // import HighlightContent from "$lib/components/highlights/HighlightContent.svelte";
    import { SubtleButton, EventCard } from "@kind0/ui-common";
    import { removeQuotedEvent, fetchQuotedHighlight } from './utils';
    import type { NDKHighlight} from "@nostr-dev-kit/ndk";
    import { AvatarWithName } from "@kind0/ui-common";
    import { onDestroy } from "svelte";
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
        console.log(h)
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
</script>

{#if highlight}
    <EventCard
        {event}
        authorAction="margin note by"
        skipHeader={skipTitle}
        class={$$props.class}
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
                            <Avatar {user} ndk={$ndk} class="inline-block h-7 w-7 rounded-full" />
                        {/each}
                    </div>

                    <div class="truncate text-xs">
                        <Name user={chooseUsersToDisplay(replyingUsersIds, 1)[0]} ndk={$ndk} />
                        {#if replyingUsersIds.size > 1}
                            <span>and {replyingUsersIds.size - 1} others</span>
                        {/if} commented
                    </div>
                {/if}
            </div>

            <div>
                <SubtleButton
                    on:click={(e) => { replying = true; e.stopPropagation(); }}
                >
                    Add your thoughts
                </SubtleButton>
            </div>
        </div>
    </EventCard>
{/if}