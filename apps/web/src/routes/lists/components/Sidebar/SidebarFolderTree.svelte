<script lang="ts">
    import SidebarFolderBranch from '$lib/components/Sidebar/SidebarFolderBranch.svelte';
    import type { NDKList } from '@nostr-dev-kit/ndk';

    import { userLists } from '$stores/session';

    import { debounce } from 'throttle-debounce';

    /**
     * Only display lists of these kinds
     */
    export let kinds: number[] | undefined = undefined;

    let renderedList: NDKList[] | undefined = undefined;

    const updatedRenderedLists = debounce(300, () => {
        const lists: NDKList[] = Array.from($userLists.values());
        renderedList =lists.filter(shouldDisplay);
    });

    $: if (renderedList?.length !== $userLists.size) {
        updatedRenderedLists();
    }

    function shouldDisplay(list: NDKList) {
        const hasRightKind = kinds ? kinds.includes(list.kind!) : true;
        return hasRightKind && isTopLevel(list);
    }

    function isTopLevel(thisList: NDKList) {
        for (const _list of $userLists.values()) {
            const referenced = _list.tags.find((t) => t[1] === thisList.tagId());
            const notReferencedByItself = _list.tags.find((t) => t[1] !== _list.tagId()); // that is not itself
            if (referenced && notReferencedByItself) {
                return false;
            }
        }
        return true;
    }
</script>

{#if renderedList}

    {#if renderedList.length > 0}
        {#if $$slots.collapsableTitle}
            <li class="menu-title flex flex-row items-center">
                <details open={$$props.open} class="w-full">
                    <summary class="flex flex-row items-center w-full">
                        <slot name="collapsableTitle" />
                    </summary>

                    {#each renderedList as item}
                        <SidebarFolderBranch
                            href={`/lists/${item.encode()}`}
                            {item}
                        />
                    {/each}
                </details>
            </li>
        {:else if $$slots.title}
            <slot name="title" />
        {/if}

        {#if !$$slots.collapsableTitle}
            {#each renderedList as item}
                <SidebarFolderBranch
                    href={`/lists/${item.encode()}`}
                    {item}
                />
            {/each}
        {/if}
    {/if}
{:else}
    <span class="loading loading-lg"></span>
{/if}
