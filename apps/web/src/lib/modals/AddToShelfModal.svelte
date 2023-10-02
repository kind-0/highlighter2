<script lang="ts">
    import { user, userShelves } from '$stores/session';
    import { ndk } from "@kind0/ui-common";

    import { closeModal } from 'svelte-modals';
    import type { NDKEvent, NostrEvent } from '@nostr-dev-kit/ndk';
    import {ModalWrapper} from '@kind0/ui-common';
    import { Input } from "@kind0/ui-common";
    import { Textarea } from '@kind0/ui-common';
    import {  getLists } from "$lib/stores/list";

    import { NDKKind, NDKList } from "@nostr-dev-kit/ndk";
    import ModalButton from '$lib/components/ModalButton.svelte';

    let name: string;
    
    let description: string;

    export let kind = NDKKind.CategorizedHighlightList;
    export let event: NDKEvent;
    export let onModalClose = async () => {return}

    async function createNewList() {
        const list = new NDKList($ndk, {kind} as NostrEvent);
        list.name = name;
        list.description = description;
        await list.addItem(event.tagReference());
        await list.publish();
        if ($user) {
            getLists($user);
        }
        closeModal();
    }

    async function addToList(list: NDKList) {
        list.ndk = $ndk;
        await list.addItem(event.tagReference());
        await list.sign();
        await list.publish();
        closeModal();
    }
</script>

<ModalWrapper
    class=""
    title="Add to Reading shelf"
    {onModalClose}
>
    <div class="flex flex-row flex-nowrap justify-center gap-8">
        <div class="flex flex-col gap-8 border-2 border-base-300 p-4 rounded-box w-full">
            <div class="flex flex-col gap-4">
                <h1 class="text-2xl font-bold">
                    New Reading Shelf
                </h1>

                <div class="flex flex-col join join-vertical">
                    <Input type="text" class="
                        border-0
                        mb-1
                        bg-base-100
                        w-full
                        focus:ring-0
                        join-item
                        text-xl
                    " placeholder="Name" bind:value={name} autofocus />
                    <Textarea class="
                        border-0
                        join-item
                        text-lg
                    " placeholder="Description" bind:value={description} />
                </div>

                <ModalButton on:click={createNewList}>
                    CREATE
                </ModalButton>
            </div>
        </div>

        {#if $userShelves.length > 0}
            <div class="flex flex-col gap-8 border-2 border-base-300 p-4 rounded-box">
                <div class="flex flex-col gap-4">
                    <h1 class="text-2xl font-bold">
                        Add to existing shelf
                    </h1>

                    <ul class="menu w-full rounded-box !bg-base-100 overflow-y-auto overflow-x-hidden max-h-48">
                        {#each $userShelves as list}
                            <li>
                                <button on:click={() => addToList(list)}>{list.name}</button>
                            </li>
                        {/each}
                    </ul>
                </div>
            </div>
        {/if}
    </div>
</ModalWrapper>
