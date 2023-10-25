<script lang="ts">
	import { openModal } from 'svelte-modals';
	import SupportAuthorModal from '$modals/SupportAuthorModal.svelte';
    import { AttentionButton, Name, PrimaryButton, ndk, nicelyFormattedMilliSatNumber, nicelyFormattedSatNumber } from "@kind0/ui-common";
    import { NDKKind, type NDKFilter, type NDKUser, NDKArticle, NDKEvent, type NostrEvent } from "@nostr-dev-kit/ndk";

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

<!-- {#await supportEvent then event} -->
    <div class="card !bg-accent2/10 border border-accent2/30 mb-8">
        <div class="card-body">
            {#if event}
                <div class="card-title text-base-100-content text-2xl">
                    {event.title}
                </div>

                {#await user.fetchProfile() then profile}
                    <p class="text-base">
                        {profile?.bio??profile?.about}
                    </p>
                {/await}
            {:else}
                Support
                <Name {user} />
            {/if}

            <AttentionButton class="text-base-100-content !text-base w-fit !px-8 mt-4" on:click={openSupport}>
                Subscribe
                <span class="font-thin">to support</span>
                <Name {user} />
            </AttentionButton>
        </div>
    </div>
<!-- {/await} -->

<style lang="postcss">
    .card-action {
        @apply self-end;
    }
</style>