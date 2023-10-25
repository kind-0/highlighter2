<script lang="ts">
    import { user, userShelves } from '$stores/session';
    import { ModalButton, SubtleButton, ndk } from "@kind0/ui-common";

    import { closeModal } from 'svelte-modals';
    import type { NDKEvent, NostrEvent } from '@nostr-dev-kit/ndk';
    import {ModalWrapper} from '@kind0/ui-common';
    import { Input } from "@kind0/ui-common";
    import { Textarea  } from '@kind0/ui-common';

    import {  getLists } from "$lib/stores/list";

    import { NDKKind, NDKList } from "@nostr-dev-kit/ndk";
    import { sleep } from '$utils/sleep';
    import Button from '$components/buttons/Button.svelte';

    let name: string;
    let description: string;

    let _loading = false;
    let _showExistingShelf = true;
    let showNewForm = false;

    export let kind = NDKKind.CategorizedHighlightList;
    export let event: NDKEvent;

    const validateForm = async (): Promise<string | undefined> => {
        let result = undefined
        if(!name) {
            result = `Please enter a name`
        }
        return result
    }

    async function createNewList() {
        let formValidationResult = await validateForm()
        if(!!formValidationResult) {
            alert(formValidationResult);
            return;
        }

        let addListEventTagRef = event.tagReference()

        try {
            _loading = true;
            const list = new NDKList($ndk, {kind} as NostrEvent);
            list.name = name;
            list.description = description;
            await list.addItem(addListEventTagRef);
            await list.publish();
            if ($user) {
                getLists($user);
            }
            showNewForm = true
            closeModal();
        } catch(e) {
            console.log(`add to shelf modal error: `, e);
            //_loading = false
        }
        finally {
            _loading = false
        }
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
    title="Add to Reading shelf"
    class="max-w-md"
>
    <div class="flex flex-col justify-start gap-4">
        <div class="flex flex-col gap-8 rounded-box w-full">
            {#if $userShelves.length > 0 && _showExistingShelf}
                <div class="flex flex-col gap-4">
                    <ul class="menu w-full rounded-box !bg-base-100 overflow-y-auto overflow-x-hidden max-h-48">
                        {#each $userShelves as list}
                            <li>
                                <button on:click={() => addToList(list)}>{list.name}</button>
                            </li>
                        {/each}
                    </ul>
                </div>
            {:else}
                <div class="flex flex-col gap-4 justify-between">
                    <div class="flex flex-col gap-4">
                        <div class="flex flex-col gap-1 join join-vertical">
                            <Input type="text" class="
                                border-0
                                bg-base-100
                                focus:ring-0
                                w-full
                                join-item
                                text-lg
                            " placeholder="Name" bind:value={name} autofocus />
                            <Textarea class="
                                border-0
                                bg-base-100
                                focus:ring-0
                                join-item
                                text-lg
                            " placeholder="Description" rows={7} bind:value={description} />
                        </div>
                    </div>

                    <ModalButton on:click={createNewList} loading={_loading}>
                        CREATE
                    </ModalButton>
                </div>
            {/if}
        </div>

        {#if !showNewForm}
            <SubtleButton class="w-full" on:click={() => _showExistingShelf = false}>
                {`Create new`}
            </SubtleButton>
        {:else}
            <div class="flex flex-col w-full justify-center items-center gap-4">
                <div class="flex flex-row justify-center items-center gap-2 text-success">
                    <p class="font-sans font-medium text-base">
                        Success
                    </p>
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="3.5" stroke="currentColor" class="w-4 h-4">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                </div>
                <div class="flex flex-col w-full justify-center items-center p-4 gap-4 bg-base-300/40 rounded-xl">
                    <p class="font-sans font-medium text-base">
                        Created new shelf
                    </p>
                    <p class="font-sans font-medium text-base">
                        "{name}"
                    </p>
                </div>
            </div>
        {/if}
    </div>
</ModalWrapper>
