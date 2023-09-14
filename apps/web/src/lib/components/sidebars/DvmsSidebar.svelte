<script lang="ts">
	import { userDVMRequests } from '$stores/session.ts';
	import { userFollows } from '$stores/session';
    import SidebarFolders from "../Sidebar/SidebarFolders.svelte";
    import MenuItem from './MenuItem.svelte';
    import { sortedHighlightList, sortedUserList } from "$lib/stores/list";
    import { user, userFollowHashtags } from "$stores/session";
    import ReaderIcon from "$icons/ReaderIcon.svelte";
    import {DvmIcon, SidebarSectionLink} from '@kind0/ui-common';
    import Highlight from "$icons/Highlight.svelte";
    import CardWithTitle from "$components/cards/CardWithTitle.svelte";
    import Hashtag from "$icons/Hashtag.svelte";
    import RelaySetButton from "$components/Sidebar/RelaySetButton.svelte";
    import { highlights } from "$stores/session";
    import { derived } from 'svelte/store';
    import SidebarJobRequestItem from '../../../routes/web/components/Sidebar/SidebarJobRequestItem.svelte';

    let hasUserHighlights = false;
    let hasNetworkHighlights = false;

    $: {
        hasUserHighlights = !!($user && Array.from($highlights).some(([key, h]) => $user?.hexpubkey));

        if ($userFollows) {
            const userFollowsPubkeys = Array.from($userFollows);
            hasNetworkHighlights = !!(Array.from($highlights).some(([key, h]) => userFollowsPubkeys.includes(h.pubkey)));
        }
    }

    const userJobs = derived(userDVMRequests, $userDVMRequests => {
        if (!$userDVMRequests) {
            return [];
        }

        const allJobs = Array.from($userDVMRequests.values()).flat();

        return allJobs.sort((a, b) => a.created_at! - b.created_at!);
    });
</script>

<div class="flex flex-col items-center gap-8">
    <SidebarSectionLink
        href="/reader"
        title="Reader"
    >
        <span slot="icon"><ReaderIcon class="w-6 h-6 text-accent2" /></span>
    </SidebarSectionLink>

    <CardWithTitle
        icon={DvmIcon}
        iconClass="text-accent w-5 h-5"
        title="DVMs"
    >
        <ul class="menu bg-base-200 w-full rounded-box overflow-clip">
            {#each $userJobs as jobRequest (jobRequest.id)}
                <SidebarJobRequestItem {jobRequest} />
            {/each}
        </ul>
    </CardWithTitle>

    <CardWithTitle
        icon={Highlight}
        iconClass="text-accent w-5 h-5"
        title="Highlighter"
    >
        <ul class="menu bg-base-200 w-full rounded-box">
            <RelaySetButton />
            <li class="menu-title">PROFILES</li>
            {#if hasUserHighlights}
                <MenuItem href="/highlights/me" activeClass="border-l-accent">
                    Just you
                </MenuItem>
            {/if}
            {#if hasNetworkHighlights}
                <MenuItem href="/highlights" activeClass="border-l-accent">
                    Following
                </MenuItem>
            {/if}
            <MenuItem href="/highlights/local" activeClass="border-l-accent">
                Local
            </MenuItem>

            {#if $sortedUserList}
                {#each $sortedUserList as user}
                    <MenuItem href="/highlights/{user.id}" activeClass="border-l-accent">
                        {user.name}
                    </MenuItem>
                {/each}
            {/if}

            {#if $userFollowHashtags && $userFollowHashtags.length > 0}
                <li class="menu-title">TOPICS</li>
                {#each $userFollowHashtags as hashtag}
                    <MenuItem
                        href="/t/{hashtag}"
                        activeClass="border-l-accent"
                        innerClass="flex flex-row gap-2"
                    >
                        <Hashtag class="w-6 h-6 !text-base-300-content" />
                        {hashtag}
                    </MenuItem>
                {/each}
            {/if}

            <SidebarFolders
                title="LISTS"
                list={sortedUserList}
                linkPrefix="/highlights/"
                linkSuffix=""
            />

            <SidebarFolders title="SHELVES" list={sortedHighlightList} />
        </ul>
    </CardWithTitle>

</div>

<style>
    :global(* > li a.active) {
        font-weight: black !important;
    }
</style>