<script lang="ts">
    import { user } from '$stores/session';
    import { ModalButton, ndk } from "@kind0/ui-common";

    import { closeModal } from 'svelte-modals';
    import type { NostrEvent } from '@nostr-dev-kit/ndk';
    import { goto } from '$app/navigation';
    import {ModalWrapper} from '@kind0/ui-common';
    import { Input } from "@kind0/ui-common";
    import { Textarea } from '@kind0/ui-common';
    import {  getLists } from "$lib/stores/list";

    import { NDKList } from "@nostr-dev-kit/ndk";

    let name: string;
    let description: string;

    export let kind = 30001;

    async function createNewList() {
        const list = new NDKList($ndk, {kind} as NostrEvent);
        list.name = name;
        list.description = description;
        await list.publish();
        if ($user) {
            getLists($user);
        }
        goto(`/lists/${list.encode()}`);
        closeModal();
    }
</script>

<ModalWrapper
    class="max-w-sm"
    title="New List"
>
    <div class="flex flex-col gap-8">
        <div class="flex flex-col join join-vertical">
            <Input type="text" class="
                border-0
                mb-1
                bg-base-100
                w-full
                join-item
                text-xl
            " placeholder="Name" bind:value={name} autofocus />
            <Textarea class="
                border-0
                join-item
                text-sm
            " placeholder="Description" bind:value={description} />
        </div>

        <ModalButton on:click={createNewList}>
            CREATE
        </ModalButton>
    </div>
</ModalWrapper>
