<script>
	import { userFollows } from '$stores/session';
	import {AtlasNotesLogo} from '@kind0/ui-common';
    import SidebarFolders from "../Sidebar/SidebarFolders.svelte";
    import MenuItem from './MenuItem.svelte';
    import { sortedHighlightList, sortedUserList } from "$lib/stores/list";
    import { user } from "$stores/session";
    import ReaderIcon from "$icons/ReaderIcon.svelte";
    import {SidebarSectionLink, HighlightIcon} from '@kind0/ui-common';
    import CardWithTitle from "$components/cards/CardWithTitle.svelte";
    import RelaySetButton from "$components/Sidebar/RelaySetButton.svelte";
    import { highlights } from "$stores/session";
    import InterestMenuItems from './InterestMenuItems.svelte';

    let hasUserHighlights = false;
    let hasNetworkHighlights = false;

    $: {
        hasUserHighlights = !!($user && Array.from($highlights).some(([key, h]) => $user?.hexpubkey));

        if ($userFollows) {
            const userFollowsPubkeys = Array.from($userFollows);
            hasNetworkHighlights = !!(Array.from($highlights).some(([key, h]) => userFollowsPubkeys.includes(h.pubkey)));
        }
    }


</script>

<div class="flex flex-col items-center gap-8">
    <SidebarSectionLink
        href="/reader"
        title="Reader"
    >
        <span slot="icon"><ReaderIcon class="w-6 h-6 text-accent2" /></span>
    </SidebarSectionLink>

    <CardWithTitle
        icon={HighlightIcon}
        iconClass="text-accent w-5 h-5"
        title="Highlighter"
    >
        <ul class="menu bg-base-200 w-full rounded-box">
            <!-- <RelaySetButton /> -->
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

            <InterestMenuItems />

            <SidebarFolders
                title="LISTS"
                list={sortedUserList}
                linkPrefix="/highlights/"
                linkSuffix=""
            />

            <SidebarFolders title="SHELVES" list={sortedHighlightList} />
        </ul>
    </CardWithTitle>

    <SidebarSectionLink
        href="/lists"
        class="!h-fit"
    >
        <div class="flex flex-col gap-4 items-start justify-stretch py-4 text-left">
            <AtlasNotesLogo class="w-6 h-6 text-accent2" />
            <span class="!font-light">
                A phenomenal personal information management tool,
                built right in nostr.
            </span>
        </div>
    </SidebarSectionLink>
</div>

<style>
    :global(* > li a.active) {
        font-weight: black !important;
    }
</style>