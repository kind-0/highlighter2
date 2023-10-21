<script lang="ts">
    import { AttentionButton, Avatar, HighlightIcon, Name, ShelvesIcon } from "@kind0/ui-common";
    import type { NDKUser } from '@nostr-dev-kit/ndk';
    import { Newspaper } from 'phosphor-svelte';
    import { page } from '$app/stores';
    import MenuItem from '$components/sidebars/MenuItem.svelte';
    import CardWithTitle from "$components/cards/CardWithTitle.svelte";

    export let user: NDKUser;

    const {id} = $page.params;

    let bio: string | undefined;

    $: bio = user.profile?.bio??user.profile?.about;
</script>

<div class="flex flex-col items-center gap-8">
    <CardWithTitle
        iconClass="text-accent w-5 h-5"
        href={`/p/${id}`}
    >
        <div slot="icon">
            <Avatar {user} class="w-12 h-12 rounded-lg" />
        </div>

        <span slot="title">
            <Name {user} class="text-lg font-semibold truncate" />
        </span>

        <ul class="menu">
            <MenuItem
                href="/p/{id}/highlights"
                class="w-full"
                innerClass="flex flex-row items-center gap-5 flex-grow"
            >
                <HighlightIcon class="w-4 h-4" />
                Highlights
            </MenuItem>
            <MenuItem
                href="/p/{id}/lists"
                class="w-full"
                innerClass="flex flex-row items-center gap-5 flex-grow"
            >
                <ShelvesIcon class="w-4 h-4" />
                Shelves
            </MenuItem>
            <MenuItem
                href="/p/{id}/articles"
                class="w-full"
                innerClass="flex flex-row items-center gap-5 flex-grow"
            >
                <Newspaper class="w-4 h-4" />
                Writing
            </MenuItem>
        </ul>

        <div class="divider my-2"></div>

        <ul class="menu w-full">
            <li class="menu-title">
                SUPPORTERS
            </li>
        </ul>

        <div class="flex flex-row">

            <AttentionButton href="/p/{id}/support" class="">
                Support
            </AttentionButton>
        </div>

    </CardWithTitle>
</div>