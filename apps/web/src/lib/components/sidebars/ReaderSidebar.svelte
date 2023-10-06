<script>
    import ReaderIcon from '$icons/ReaderIcon.svelte';
    import CardWithTitle from '$components/cards/CardWithTitle.svelte';
    import {Avatar, HighlightIcon, SidebarSectionLink} from '@kind0/ui-common';
    import InterestMenuItems from './InterestMenuItems.svelte';
    import { ArrowArcRight, List } from 'phosphor-svelte';
    import { userShelves, networkShelves, user } from '$stores/session';
    import Curation from '$icons/Curation.svelte';
    import MenuItem from './MenuItem.svelte';
</script>

<div class="flex flex-col gap-8 w-full">
    <SidebarSectionLink
        href="/highlights"
        title="Highlighter"
    >
        <span slot="icon"><HighlightIcon class="w-5 h-5 text-accent" /></span>
    </SidebarSectionLink>

    <CardWithTitle
        icon={ReaderIcon}
        title="Reader"
        href="/reader"
    >
        <ul class="menu bg-base-200 w-full rounded-box">
            <li class="menu-title">CURATIONS</li>

            {#each $userShelves as userShelf (userShelf.id)}
                {#if userShelf.items.length > 0}
                    <MenuItem
                        href="/reader/{userShelf.encode()}"
                        innerClass="flex flex-row items-center gap-2"
                    >
                        <Avatar pubkey={userShelf.pubkey} size="tiny" type="square" />
                        {userShelf.name}
                    </MenuItem>
                {/if}
            {/each}

            {#each $networkShelves as networkShelf}
                {#if networkShelf.items.length > 0 && networkShelf.pubkey !== $user?.hexpubkey}
                    <li>
                        <a href="/reader/{networkShelf.encode()}">
                            <Avatar pubkey={networkShelf.pubkey} size="tiny" type="square" />
                            {networkShelf.name}
                        </a>
                    </li>
                {/if}
            {/each}

            <MenuItem
                href="/reader/curations"
                innerClass="flex flex-row items-center gap-2"
            >
                <Curation />
                Explore
            </MenuItem>

            <InterestMenuItems />
        </ul>
    </CardWithTitle>
</div>