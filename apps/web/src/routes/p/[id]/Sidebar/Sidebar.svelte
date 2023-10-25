<script lang="ts">
	import SupportAuthorModal from '$modals/SupportAuthorModal.svelte';
    import { AttentionButton, Avatar, HighlightIcon, Name, ShelvesIcon } from "@kind0/ui-common";
    import type { NDKUser } from '@nostr-dev-kit/ndk';
    import { Newspaper } from 'phosphor-svelte';
    import { page } from '$app/stores';
    import MenuItem from '$components/sidebars/MenuItem.svelte';
    import CardWithTitle from "$components/cards/CardWithTitle.svelte";
    import { getUserSupporters } from "$stores/user-view.js";
    import { openModal } from "svelte-modals";

    export let user: NDKUser;

    const {id} = $page.params;

    let bio: string | undefined;

    $: bio = user.profile?.bio??user.profile?.about;

    const userSupporters = getUserSupporters();

    function openSupport() {
        openModal(SupportAuthorModal, { user })
    }
</script>

<div class="flex flex-col items-center gap-8">
    <CardWithTitle
        iconClass="text-accent w-5 h-5"
        href={`/p/${id}`}
    >
        <div slot="icon" class="shrink-0">
            <Avatar {user} class="w-12 h-12 rounded-lg" />
        </div>

        <span slot="title" class="truncate">
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
            <li class="menu-title mb-4">
                SUPPORTERS
            </li>
            <li class="flex flex-row items-center justify-between">
                {#if $userSupporters.length > 0}
                    <div class="flex flex-row flex-wrap avatar-group justify-center gap-6">
                        {#each $userSupporters as supporter (supporter.id)}
                            <Avatar user={supporter.author} class="w-12 h-12 border-0" type="circle" />
                        {/each}
                    </div>
                {/if}

                <AttentionButton class="w-full" on:click={openSupport}>
                    Support
                </AttentionButton>
            </li>
        </ul>

    </CardWithTitle>
</div>