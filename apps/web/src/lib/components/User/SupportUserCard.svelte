<script lang="ts">
	import { openModal } from 'svelte-modals';
	import SupportAuthorModal from '$modals/SupportAuthorModal.svelte';
    import { AttentionButton, Name } from "@kind0/ui-common";
    import type { NDKUser } from "@nostr-dev-kit/ndk";
    import { Lightning } from 'phosphor-svelte';

    export let user: NDKUser;

    function openSupport() {
        openModal(SupportAuthorModal, { user })
    }

    // const supportEvent = new Promise<NDKArticle|null>((resolve) => {
    //     $ndk.fetchEvent({
    //         authors: [user.pubkey],
    //         kinds: [NDKKind.Article],
    //         // "#d": ["38iu6ttnk6zw3wdd"]
    //         // "#d": ["patron"],
    //     }).then((event) => {
    //         if (event) {
    //             const article = NDKArticle.from(event);

    //             // stub
    //             article.title = "Hey there, reader!";

    //             resolve(article);
    //         } else {
    //             resolve(null);
    //         }
    //     })
    // })
</script>

<div class="card !bg-accent2/10 border border-accent2/30">
    <div class="card-body">
        <div class="card-title text-base-100-content text-2xl">
            <span class="font-thin">Subscribe to </span>
            <Name {user} />
        </div>

            {#await user.fetchProfile() then profile}
                <p class="text-base">
                    {profile?.bio??profile?.about}
                </p>
            {/await}

        <AttentionButton color="accent2" class="text-base-100-content !text-base w-fit !px-8 mt-4" on:click={openSupport}>
            <Lightning class="w-4 h-4 text-accent2" weight="fill" />
            Subscribe
            <span class="font-thin">to support</span>
            <Name {user} />
        </AttentionButton>
    </div>
</div>

<style lang="postcss">
    .card-action {
        @apply self-end;
    }
</style>