<script lang="ts">
    import { user, userShelves } from '$stores/session';
    import { ModalButton, SubtleButton, ndk, newToasterMessage } from "@kind0/ui-common";

    import { closeModal } from 'svelte-modals';
    import type { NDKEvent, NostrEvent } from '@nostr-dev-kit/ndk';
    import {ModalWrapper} from '@kind0/ui-common';
    import { Input } from "@kind0/ui-common";
    import { Textarea  } from '@kind0/ui-common';

    import {  getLists } from "$lib/stores/list";

    import { NDKKind, NDKList } from "@nostr-dev-kit/ndk";
    import { slide } from 'svelte/transition';

    let name: string;
    let description: string;

    let loading = false;

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
            loading = true;
            const list = new NDKList($ndk, {kind} as NostrEvent);
            list.title = name;
            list.description = description;
            await list.addItem(addListEventTagRef);
            await list.publish();
            if ($user) {
                getLists($user);
            }
            closeModal();
            newToasterMessage(`List ${list.title} created`, "success")
        } catch(e) {
            console.log(`add to shelf modal error: `, e);
            //loading = false
        }
        finally {
            loading = false
        }
    }

    async function addToList(list: NDKList) {
        list.ndk = $ndk;
        await list.addItem(event.tagReference());
        await list.sign();
        // await list.publish();
        newToasterMessage("Added to list", "success")
        closeModal();
    }
</script>

<ModalWrapper
    title="Add to Reading shelf"
    class="max-w-md"
>
    <div class="flex flex-col justify-start gap-4">
        <div class="flex flex-col gap-4 rounded-box w-full">
            {#if $userShelves.length > 0}
                <div class="flex flex-col gap-4">
                    <ul class="menu w-full flex-nowrap rounded-box !bg-base-100 overflow-y-auto overflow-x-hidden max-h-48">
                        {#each $userShelves as list}
                            <li class="w-full">
                                <button on:click={() => addToList(list)}>{list.title}</button>
                            </li>
                        {/each}
                    </ul>
                </div>
            {/if}

            <div class="flex flex-col gap-4 justify-between">
                <div class="flex flex-col gap-4">
                    <div class="flex flex-col gap-1 join join-vertical">
                        <Input type="text" class="
                            border-0
                            bg-base-100
                            rounded-box
                            focus:ring-0
                            w-full
                            join-item
                            text-lg
                        " placeholder="New List" bind:value={name} autofocus />
                        {#if name && name.length > 0}
                            <div class="w-full join-item" transition:slide>
                                <Textarea class="
                                    border-0
                                    w-full
                                    resize-none
                                    bg-base-100
                                    focus:ring-0
                                    join-item
                                    text-lg
                                " placeholder="Description" bind:value={description} />
                            </div>
                        {/if}
                    </div>
                </div>

                {#if name && name.length > 0}
                    <ModalButton on:click={createNewList} loading={loading}>
                        CREATE
                    </ModalButton>
                {/if}
            </div>
        </div>
    </div>
</ModalWrapper>
