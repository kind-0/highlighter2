<script lang="ts">
    import { user, userShelves } from '$stores/session';
    import { ndk } from "@kind0/ui-common";

    import { closeModal } from 'svelte-modals';
    import type { NDKEvent, NostrEvent } from '@nostr-dev-kit/ndk';
    import {ModalWrapper} from '@kind0/ui-common';
    import { Input } from "@kind0/ui-common";
    import { Textarea  } from '@kind0/ui-common';
    
    import {  getLists } from "$lib/stores/list";

    import { NDKKind, NDKList } from "@nostr-dev-kit/ndk";
    import ModalButton from '$lib/components/ModalButton.svelte';
    import { useEffect } from '$lib/hooks/useEffect';
    import { sleep } from '$utils/sleep';

    let form_shelf_name: string;
    let form_shelf_description: string;

    let _loading = false;
    let _showExistingShelf = false
    let _showCreatedNewShelfSuccess = false

    export let kind = NDKKind.CategorizedHighlightList;
    export let event: NDKEvent;
    export let onModalClose = async () => {return}

    const validateForm = async (): Promise<string | undefined> => {
        let result = undefined
        if(!form_shelf_name) {
            result = `Please enter the name`
        }
        else if(!form_shelf_description) {
            result = `Please enter the description`
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
            await sleep(500) // add latency

            const list = new NDKList($ndk, {kind} as NostrEvent);
            list.name = form_shelf_name;
            list.description = form_shelf_description;
            await list.addItem(addListEventTagRef);
            await list.publish();
            if ($user) {
                getLists($user);
            }
            _showCreatedNewShelfSuccess = true
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

    useEffect(
		async () => {
			if(_showCreatedNewShelfSuccess) {
                await sleep(1700)
                _showCreatedNewShelfSuccess = false
            }
		},
		() => [_showCreatedNewShelfSuccess]
	);


</script>

<ModalWrapper
    title="Add to Reading shelf"
    {onModalClose}
>
    <div class="flex max-lg:flex-col flex-row flex-nowrap h-mobileModalContents justify-start gap-4">
        <div class="flex flex-row justify-start items-center pl-2 gap-1 text-neutral/80">
            {#if _showCreatedNewShelfSuccess}
                <div class="flex" />
            {:else if $userShelves.length > 0 && _showExistingShelf}
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" class="w-4 h-4">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 6v12m6-6H6" />
                </svg>              
                <button class="font-sans font-medium text-sm" on:click={() => _showExistingShelf = false}>
                    {`Create new`}
                </button>
            {:else}
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" class="w-4 h-4">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M17.593 3.322c1.1.128 1.907 1.077 1.907 2.185V21L12 17.25 4.5 21V5.507c0-1.108.806-2.057 1.907-2.185a48.507 48.507 0 0111.186 0z" />
                </svg>                  
                <button class="font-sans font-medium text-sm" on:click={() => _showExistingShelf = true}>
                    {`Add to existing shelf`}
                </button>
            {/if}
        </div>
        {#if _showCreatedNewShelfSuccess}
            <div class="flex flex-col w-full justify-center items-center gap-4">
                <div class="flex flex-row justify-center items-center gap-2 text-success">
                    <p class="font-sans font-medium text-base">
                        {`Success`}
                    </p>
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="3.5" stroke="currentColor" class="w-4 h-4">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                </div>
                <div class="flex flex-col w-full justify-center items-center p-4 gap-4 bg-base-300/40 rounded-xl">
                    <p class="font-sans font-medium text-base">
                        {`Created new shelf`}
                    </p>
                    <p class="font-sans font-medium text-base">
                        {`"${form_shelf_name}"`}
                    </p>
                </div>
            </div>
        {:else} 
            <div class="flex flex-col gap-8 border-2 border-base-300 p-4 rounded-box w-full h-full">
                {#if $userShelves.length > 0 && _showExistingShelf}
                    <div class="flex flex-col gap-4">
                        <h1 class="text-2xl font-bold">
                            Add To Existing Shelf
                        </h1>

                        <ul class="menu w-full rounded-box !bg-base-100 overflow-y-auto overflow-x-hidden max-h-48">
                            {#each $userShelves as list}
                                <li>
                                    <button on:click={() => addToList(list)}>{list.name}</button>
                                </li>
                            {/each}
                        </ul>
                    </div>
                {:else}
                    <div class="flex flex-col h-full gap-4 justify-between">
                        <div class="flex flex-col h-full gap-4">
                            <h1 class="text-2xl font-bold">
                                New Reading Shelf
                            </h1>

                            <div class="flex flex-col gap-1 join join-vertical">
                                <Input type="text" class="
                                    border-0
                                    bg-base-100
                                    focus:ring-0
                                    w-full
                                    join-item
                                    text-lg
                                " placeholder="Name" bind:value={form_shelf_name} autofocus />
                                <Textarea class="
                                    border-0
                                    bg-base-100
                                    focus:ring-0
                                    join-item
                                    text-lg
                                " placeholder="Description" rows={7} bind:value={form_shelf_description} />
                            </div>
                        </div>

                        <ModalButton on:click={createNewList} loading={_loading}>
                            CREATE
                        </ModalButton>
                    </div>
                {/if}
            </div>
        {/if}
    </div>
</ModalWrapper>
