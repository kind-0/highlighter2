<script lang="ts">
    import { openModal } from 'svelte-modals'

    import BookmarkModal from '$lib/modals/Bookmark.svelte';

    import type { NDKEvent } from '@nostr-dev-kit/ndk';
    import { user } from '$stores/session';

    export let event: NDKEvent;

    $: tooltip = $user ? 'Bookmark' : 'You are not logged in';
</script>

<div class="tooltip" data-tip={tooltip}>
    <button
        class="{$$props.class}"
        class:cursor-not-allowed={!$user}
        on:click={() => { openModal(BookmarkModal, { event }) }}
    ></button>
</div>
