<script lang="ts">
    import { goto } from "$app/navigation";
    import { addLongForm } from "$lib/stores/long-form";

    import ndk from "$lib/stores/ndk";
    import { user } from "$stores/session";
    import type { NostrEvent } from "@nostr-dev-kit/ndk";
    import { NDKArticle } from "@nostr-dev-kit/ndk";

    $: if ($user) {
        let event = new NDKArticle($ndk, {
            kind: 31023,
            pubkey: $user.hexpubkey(),
            created_at: Math.floor(Date.now() / 1000),
        } as NostrEvent);

        addLongForm(event);

        goto(`/notes/${event.encode()}/edit`);
    }
</script>

