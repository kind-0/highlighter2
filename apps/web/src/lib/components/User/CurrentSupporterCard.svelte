<script lang="ts">
    import { AttentionButton, Name } from "@kind0/ui-common";
    import type { NDKUser } from "@nostr-dev-kit/ndk";
    import { Lightning } from 'phosphor-svelte';

    export let user: NDKUser;
</script>

<div class="card !bg-accent2/10 border border-accent2/30">
    <div class="card-body">
        <div class="card-title text-base-100-content text-2xl">
            You are supporting
            <Name {user} />'s work!
        </div>

            {#await user.fetchProfile() then profile}
                <p class="text-base">
                    {profile?.bio??profile?.about}
                </p>
            {/await}

        <AttentionButton color="accent2" class="text-base-100-content !text-base w-fit !px-8 mt-4 !hidden">
            <Lightning class="w-4 h-4 text-accent2" weight="fill" />
            Manage your support
        </AttentionButton>
    </div>
</div>

<style lang="postcss">
    .card-action {
        @apply self-end;
    }
</style>