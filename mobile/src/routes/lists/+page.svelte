<script lang="ts">
    import ListCard from '$lib/components/lists/ListCard.svelte';

    import NewListModal from '$lib/modals/lists/New.svelte';

    import { openModal } from 'svelte-modals'
    import { lists } from "$lib/stores/list";

    import { derived } from 'svelte/store';
    import { ListPlus } from 'phosphor-svelte';
    import type { NDKList } from '@nostr-dev-kit/ndk';
    import { AttentionButton, PageTitle } from '@kind0/ui-common';

    const namedLists = derived(lists, ($lists) => {
        const namedLists: NDKList[] = [];

        for (const list of $lists.values()) {
            if (!!list.tagValue('name')) namedLists.push(list);
        }

        // sort by created_at
        namedLists.sort((a, b) => b.created_at - a.created_at);

        return namedLists;
    });

    const unnamedLists = derived(lists, ($lists) => {
        const unnamedLists: NDKList[] = [];

        for (const list of $lists.values()) {
            if (!list.tagValue('name')) unnamedLists.push(list);
        }

        unnamedLists.sort((a, b) => b.created_at - a.created_at);

        return unnamedLists;
    });
</script>

<svelte:head>
    <title>Lists | HIGHLIGHTER.com</title>
</svelte:head>

<PageTitle title="Organise">
    <div class="dropdown dropdown-end">
        <label tabindex="0" class="m-1 text-base">
            <AttentionButton rounded="rounded-full w-full">
                <ListPlus class="mr-4" />
                New

            </AttentionButton>
        </label>

        <ul tabindex="0" class="dropdown-content bg-base-300 z-[1] menu p-2 shadow rounded-box whitespace-nowrap">
            <li><a href="/lists/people/new">Profile List</a></li>
            <li><button on:click={() => { openModal(NewListModal, {}); }}>Generic List</button></li>
            <li><button on:click={() => { openModal(NewListModal, { kind: 30022 }); }}>Relay List</button></li>
        </ul>
    </div>
</PageTitle>

<div class="flex flex-col gap-8">
    <div class="grid grid-flow-row md:grid-cols-2 gap-4">
        {#each $namedLists??[] as list (list.id)}
            <ListCard {list} />
        {/each}
    </div>

    <div class="grid grid-flow-row md:grid-cols-2 gap-4">
        {#each $unnamedLists??[] as list (list.id)}
            <div>
                <ListCard {list} />
            </div>
        {/each}
    </div>
</div>
