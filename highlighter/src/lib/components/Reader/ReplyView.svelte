<script lang="ts">
    import { NDKEvent, type NostrEvent } from "@nostr-dev-kit/ndk";
    import { ndk } from "@kind0/lib-svelte-kit";

    import { Pen } from "phosphor-svelte";
    import { createEventDispatcher } from "svelte";
    import { Textarea } from "@kind0/ui-common";

    const dispatch = createEventDispatcher();

    export let event: NDKEvent;
    export let value: string = "";
    export let autofocus = false;

    async function publish() {
        const replyEvent = new NDKEvent($ndk, {
            kind: 1,
            content: value.trim()??"",
        } as NostrEvent);
        replyEvent.tag(event, 'reply');

        const rootEventId = event.tagValue('q');
        if (rootEventId) {
            replyEvent.tags.push(['e', rootEventId, 'root']);
        }

        await replyEvent.sign();
        await replyEvent.publish();

        dispatch('published');
    }
</script>

<!-- svelte-ignore a11y-no-static-element-interactions -->
<!-- svelte-ignore a11y-click-events-have-key-events -->
<div class="flex flex-col gap-4">
    <Textarea
        {autofocus}
        bind:value
        placeholder="Add your thoughts"
        class="
            border:base-300 border-opacity-50
            bg-transparent
            min-h-[40vh]
            min-w-[25vw]
            {$$props.class}
        "
    />

    <div class="flex flex-row justify-between">
        <div>
        </div>

        <div class="flex flex-row gap-4 items-center">

            <button
                class="btn btn-ghost btn-neutral font-normal"
                on:click={() => dispatch("cancel")}
            >
                Cancel
            </button>
            <button
                class="btn btn-outline btn-accent !rounded-full font-normal btn-lg"
                on:click={publish}
            >
                <Pen class="w-6 h-6 mr-2" />
                <span class="text-base-100-content">Save</span>
            </button>
        </div>
    </div>
</div>