<script lang="ts">
    import { goto } from '$app/navigation';
    import { page } from '$app/stores';
    import { ndk } from "@kind0/ui-common";
    import type { NDKUser } from '@nostr-dev-kit/ndk';

    let { id } = $page.params;
    let { npub } = $page.data;
    let user: NDKUser;

    if (npub.startsWith('npub')) {
        user = $ndk.getUser({npub})
    }

    // Temporary hack
    $: if (user) goto(`/p/${id}/highlights`);
</script>
