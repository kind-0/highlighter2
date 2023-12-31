<script lang="ts">
    import { user } from '$stores/session';
    import { CopyButton, PageTitle, ndk } from "@kind0/ui-common";

    import Tags from './tags.svelte';
    import type { NDKList, NDKTag } from '@nostr-dev-kit/ndk';
    import FilterFeed from '$lib/components/FilterFeed.svelte';
    import { goto } from '$app/navigation';
    import AddListItem from '$lib/components/lists/AddListItem.svelte';
    import AddRelayListItem from '$lib/components/lists/AddRelayListItem.svelte';
    import { NDKRelayList } from "@nostr-dev-kit/ndk";
    import { AvatarWithName } from "@kind0/ui-common";
    import { getSigner, type SignerStoreItem } from '$lib/stores/signer';
    import { saveEphemeralSigner } from '$lib/signers/ephemeral';
    import { getLists, processEvent } from '$lib/stores/list';
    import { writable } from 'svelte/store';
    import { DotsThree, Trash } from 'phosphor-svelte';
    import {
        Tab,
        TabGroup,
        TabList,
        TabPanel,
        TabPanels,
    } from "@rgossiaux/svelte-headlessui";


    export let list: NDKList;
    let listId;

    let publicTags: NDKTag[] = [];

    let listSignerData: SignerStoreItem | undefined;

    let visibility = 'Delegated';
    let beforeSecretVisibility = visibility;

    if (list.id !== listId) {
        listId = list.id;
        publicTags = list.tags;
    }

    /**
     * Establishes what pubkeys are going to be treated as
     * "current user"'s pubkeys
     */
    let currentUserPubkeys: string[] = [];

    if ($user) {
        currentUserPubkeys.push($user.hexpubkey);
    }

    $: if (listSignerData?.user && !currentUserPubkeys.includes(listSignerData.user.hexpubkey)) {
        currentUserPubkeys.push(listSignerData.user.hexpubkey);
    }

    async function deleteList() {
        if (!confirm('Are you sure you want to delete this list?')) {
            return;
        }

        await list.encrypt($user!);
        await list.delete();
        if ($user) {
            getLists($user);
        }
        goto('/lists');
    }

    let dropZoneActive = false;

    async function onDragEnter(e: DragEvent) {
        e.preventDefault();
        e.stopPropagation();

        // set dropZoneActive if none of the tags have this id
        const id = e.dataTransfer.getData('id');
        const tag = JSON.parse(e.dataTransfer.getData('tag'));

        dropZoneActive = !list.tags.find((t) => t[1] === id);
    }

    async function addToList(e: DragEvent) {
        const id = e.dataTransfer.getData('id');
        const tag = JSON.parse(e.dataTransfer.getData('tag'));

        if (list.tags.find((t) => t[1] === id)) {
            return;
        }

        list.tags.push(tag);
        list.created_at = Math.floor(Date.now() / 1000);
        await list.sign();
        list.publish();

        processEvent(list);
    }

    let myFeedLength: number;
    let globalFeedLength: number;

    /**
     * This callback is called when the user saves from the note editor.
     *
     * If the note has been created with a delegated signer, and the
     * key has not been saved yet, we save it here.
     */
    async function onNoteEditorSaved(e: CustomEvent) {
        const { tag, visibility } = e.detail;

        // check if we need to save an ephemeral key
        if (visibility === 'Delegated' && !listSignerData?.saved) {
            if (!listSignerData?.signer) {
                alert('no signer found');
                return;
            }

            try {
                await saveEphemeralSigner($ndk, listSignerData.signer, {
                    associatedEvent: list,
                    keyProfile: {
                        name: listSignerData.name,
                        picture: $user?.profile?.image,
                        lud06: $user?.profile?.lud06,
                        lud16: $user?.profile?.lud16,
                    },
                });
            } catch (e) {
                console.error(e);
                throw e;
            }
        }
    }

    let fetchingSigner = false;

    $: if (list && listSignerData?.id !== list.encode() && !fetchingSigner) {
        fetchingSigner = true;
        listSignerData = undefined;
        getSigner(list)
            .then((d) => {
                listSignerData = d;
                fetchingSigner = false;
            })
            .catch((e) => {
                console.error(e);
                listSignerData = undefined;
                fetchingSigner = false;
            });
    }

    const encryptedTags = writable<NDKTag[]>([]);
    let encryptedTagsTimestamp: number;

    $: if (list.created_at !== encryptedTagsTimestamp) {
        encryptedTagsTimestamp = list.created_at!;
        list.encryptedTags().then((tags) => {
            encryptedTags.set(tags);
        });
    }

    let selectedIndex = 0;
</script>

<svelte:head>
    <title>{list.name}</title>
</svelte:head>

<div class="flex flex-col gap-4 lg:gap-8 max-w-prose">
    <div class="flex flex-row gap-4 items-start">
        <PageTitle
            title={list.name??"Untitled List"}
            subtitle={list.description}
        >
            <div class="flex flex-row items-center gap-4">
                <div class="dropdown">
                    <!-- svelte-ignore a11y-no-noninteractive-tabindex -->
                    <!-- svelte-ignore a11y-label-has-associated-control -->
                    <label tabindex="0" class="btn btn-sm btn-base-100 btn-circle">
                        <DotsThree class="w-4 h-4" />
                    </label>

                    <!-- svelte-ignore a11y-no-noninteractive-tabindex -->
                    <ul tabindex="0" class="dropdown-content z-[1] menu p-2 shadow bg-base-300 rounded-box">
                        {#if listSignerData?.saved}
                            <li class="flex flex-row items-center">
                                <CopyButton class="flex text-base brightness-150 flex-col items-start" data={listSignerData?.user.npub} label="Copy lists' npub">
                                    <span class="text-xs text-base-300-content brightness-75 ml-6 font-normal w-56">
                                        You can tag this list in any note to make those notes appear in its feed.
                                    </span>
                                </CopyButton>
                            </li>
                        {/if}

                        <li class="flex flex-row items-center gap-2 w-full">
                            <CopyButton class="w-full flex text-base brightness-150 flex-col items-start" data={list.encode()} label="Copy List ID" />
                        </li>

                        <li class="flex flex-row items-center gap-2 w-full">
                            <CopyButton class="w-full flex text-base brightness-150 flex-col items-start" data={list.rawEvent()} label="Copy List JSON" />
                        </li>

                        <li class="">
                            <button class="flex flex-row gap-2 text-base brightness-150 items-start" on:click={deleteList}>
                                <Trash class="w-4 h-4" />
                                Delete List
                            </button>
                        </li>
                    </ul>
                </div>

            </div>
        </PageTitle>
    </div>

    <div class="flex flex-col sm:max-w-3xl gap-2 w-full">
        {#if list instanceof NDKRelayList}
            <AddRelayListItem {list} />
        {:else if listSignerData}
            <AddListItem
                {list}
                bind:visibility
                delegatedName={listSignerData.name}
                listSigner={listSignerData.signer}
                listSignerUser={listSignerData.user}
                on:saved={onNoteEditorSaved}
            />
        {:else}
            <AddListItem {list} on:saved={onNoteEditorSaved} />
        {/if}

        <TabGroup on:change={(e) =>  selectedIndex = e.detail }>
            <TabList class="tabs">
                <Tab
                    class="tab tab-bordered {selectedIndex === 0 ? 'tab-active' : ''}"
                >Public</Tab>
                <Tab
                    class="tab tab-bordered {selectedIndex === 1 ? 'tab-active' : ''}"
                >Secret</Tab>

                {#if listSignerData?.saved && $user}
                    <Tab
                        class="tab tab-bordered {selectedIndex === 2 ? 'tab-active' : ''}"
                    >{`My Feed ${myFeedLength > 0 ? `(${myFeedLength})` : ''}`}</Tab>
                    <Tab
                        class="tab tab-bordered {selectedIndex === 3 ? 'tab-active' : ''}"
                    >Global Feed {globalFeedLength > 0 ? `(${globalFeedLength})` : ''}</Tab>
                {/if}

                <Tab
                    class="tab tab-bordered {selectedIndex === 4 ? 'tab-active' : ''}"
                >Similar Lists' Feed</Tab>
            </TabList>

            <TabPanels>
                <TabPanel>

                    <div
                        on:dragenter={onDragEnter}
                        on:dragleave={() => (dropZoneActive = false)}
                        on:drop={(e) => {
                            addToList(e);
                            dropZoneActive = false;
                        }}
                        ondragover="return false"
                        class="
                            {dropZoneActive ? 'bg-zinc-300' : ''}
                            rounded-xl
                            transition duration-200 ease-in-out
                            py-2
                        "
                    >
                        <Tags {list} tags={list.tags} {currentUserPubkeys} />
                    </div>
                </TabPanel>

                <TabPanel>

                    <Tags {list} tags={$encryptedTags} {currentUserPubkeys} encrypted={true} />

                </TabPanel>

                {#if listSignerData?.saved && $user}
                    <TabPanel>
                        {#if myFeedLength === 0}
                            <div
                                class="
                                flex flex-col gap-4
                                rounded-xl
                                mb-4 p-4
                            "
                            >
                                <p>
                                    This tab shows mentions <em>you</em> have done of this list's account
                                    <AvatarWithName pubkey={listSignerData.user.hexpubkey} />
                                </p>

                                <p>You can use this feature to mention things you would like to have show up in this feed.</p>
                            </div>
                        {/if}
                        <FilterFeed
                            filter={{
                                kinds: [1, 9802, 4, 30023],
                                '#p': [listSignerData.user.hexpubkey],
                                authors: [$user.hexpubkey],
                            }}
                            bind:feedLength={myFeedLength}
                        />
                    </TabPanel>

                    <TabPanel>

                        {#if globalFeedLength === 0}
                            <div
                                class="
                                flex flex-col gap-4
                                bg-orange-500/10
                                rounded-xl
                                mb-4 p-4
                            "
                            >
                                <p>
                                    This tab shows <b>all</b> mentions of this list's account
                                    <AvatarWithName pubkey={listSignerData.user.hexpubkey} size="xs" />
                                </p>

                                <p>You can use this feature to allow other people to suggest you to add things to this list.</p>
                            </div>
                        {/if}
                        <FilterFeed
                            filter={{
                                kinds: [1, 9802, 4, 30023],
                                '#p': [listSignerData.user.hexpubkey],
                            }}
                            bind:feedLength={globalFeedLength}
                            eventFilter={(e) => e.pubkey !== $user.hexpubkey}
                        />

                    </TabPanel>
                {/if}
            </TabPanels>
        </TabGroup>
    </div>
</div>
