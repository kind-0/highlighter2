<script>
    import Relays from "$lib/icons/Relays.svelte";
    import { BookBookmark, Users } from "phosphor-svelte";
    import {HighlightIcon, SidebarSectionLink} from '@kind0/ui-common';
    import SidebarFolderTree from "./SidebarFolderTree.svelte";
    import RelaySetButton from "$lib/components/Sidebar/RelaySetButton.svelte";
    import SidebarUnsavedNotes from "$lib/components/Sidebar/SidebarUnsavedNotes.svelte";
    import Logo from "$icons/Logo.svelte";
    import { NDKKind } from "@nostr-dev-kit/ndk";
</script>

<div class="flex flex-col gap-8 pr-4 max-h-full overscroll-y-auto overflow-x-hidden">
    <!-- <ul class="menu bg-base-200 w-full rounded-box">
        <RelaySetButton />
    </ul> -->

    <ul class="menu bg-base-200 w-full rounded-box">

        <SidebarUnsavedNotes />

        <SidebarFolderTree kinds={[NDKKind.CategorizedHighlightList]}>
            <div slot="title">
                <li class="menu-title flex flex-row items-center">
                    <HighlightIcon class="w-4 h-4 mr-2 text-accent" />
                    HIGHLIGHTS
                </li>
            </div>
        </SidebarFolderTree>

        <SidebarFolderTree kinds={[NDKKind.GenericList]} open={false}>
            <div slot="collapsableTitle" class="flex flex-row gap-2 items-center w-full">
                <BookBookmark class="w-4 h-4 mr-2" />
                GENERIC
            </div>
        </SidebarFolderTree>

        <SidebarFolderTree kinds={[NDKKind.UserList]}>
            <div slot="collapsableTitle" class="flex flex-row gap-2 items-center w-full">
                <Users class="w-4 h-4 mr-2" />
                PROFILES
            </div>
        </SidebarFolderTree>

        <SidebarFolderTree kinds={[NDKKind.RelayList]}>
            <div slot="collapsableTitle" class="flex flex-row gap-2 items-center w-full">
                <Relays class="w-4 h-4 mr-2" />
                RELAY SETS
            </div>
        </SidebarFolderTree>
    </ul>

    <SidebarSectionLink
        href="/highlights"
        title="Highlighter"
    >
        <div slot="icon"><Logo /></div>
    </SidebarSectionLink>
</div>

