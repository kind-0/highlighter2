<script lang="ts">
    import Section from "$components/Section.svelte";
    import { page } from '$app/stores';
    import { ndk, user as currentUser, AvatarWithName } from "@kind0/ui-common";
    import { NDKArticle, zapInvoiceFromEvent, type NDKEventId, type NDKUser, type NDKZapInvoice, type Hexpubkey, NDKKind } from '@nostr-dev-kit/ndk';
    import ArticleContentCard from "$components/ContentCards/ArticleContentCard.svelte";
    import { derived, get, type Readable } from "svelte/store";
    import { getUserSupporters, userSubscription } from "$stores/user-view";
    import SupportUserCard from "$components/User/SupportUserCard.svelte";
    import CurrentSupporterCard from "$components/User/CurrentSupporterCard.svelte";

    let { id } = $page.params;
    let { npub } = $page.data;
    let user: NDKUser;

    $: {
        id = $page.params.id;
        npub = $page.data.npub;

        if (npub.startsWith('npub')) {
            try {
                user = $ndk.getUser({npub})
            } catch(e) {
                console.log(e, ` error`);
            }
        }
    }

    let articles: Readable<Map<NDKEventId, NDKArticle>>;
    let zaps: Map<Hexpubkey, number> = new Map();
    let zapPubkeys: Hexpubkey[];

    $: if (!articles && $userSubscription) {
        articles = derived(userSubscription, $userSubscription => {
            const articles = new Map<NDKEventId, NDKArticle>();

            for (const event of $userSubscription) {
                if (
                    event.pubkey !== user.pubkey ||
                    event.kind !== NDKKind.Article
                ) continue;

                const id = event.encode();
                if (!articles.has(id)) articles.set(id, NDKArticle.from(event));
            }

            return articles;
        });
    }

    $: if ($userSubscription) {
        zaps.clear();
        for (const event of $userSubscription) {
            const receipt = zapInvoiceFromEvent(event);
            if (receipt) {
                if (!zaps.has(receipt.zappee)) zaps.set(receipt.zappee, 0);
                zaps.set(receipt.zappee, zaps.get(receipt.zappee)! + receipt.amount);
            }
        }

        zapPubkeys = Array.from(zaps.entries()).sort((a, b) => b[1] - a[1]).map(e => e[0]);
    }

    let expanded = false;

    const userSupporters = getUserSupporters();
</script>

<!-- {#if zaps.size > 0}
    <div class="flex flex-col gap-4">
        <div class="flex flex-col lg:flex-row items-start justify-start lg:justify-between lg:items-center px-4 lg:px-0 gap-4 lg:gap-0">
            <h1 class="text-4xl font-bold">
                Top Supporters
            </h1>
        </div>

        {#each zapPubkeys as zapPubkey}
            <div class="flex flex-row gap-2">
                <AvatarWithName
                    pubkey={zapPubkey}
                    subtitle={nicelyFormattedMilliSatNumber(zaps.get(zapPubkey)??0).toString()}
                />
            </div>
        {/each}
    </div>
{/if} -->

{#key id}
    <div class="flex flex-col gap-8">
        {#if !$userSupporters.find(e => e.pubkey === $currentUser?.pubkey)}
            <SupportUserCard {user} />
        {:else}
            <CurrentSupporterCard {user} />
        {/if}

        <Section
            title="Articles"
            on:click={() => { expanded = true; }}
        >
            {#each $articles.values() as article (article.id)}
                <ArticleContentCard {article} skipAuthor={true} />
            {/each}
        </Section>

        {#if $userSupporters.length > 0}
            <Section
                title="Supporters"
                flow="column"
            >
                {#each $userSupporters as supportEvent (supportEvent.id)}
                    <AvatarWithName  user={supportEvent.author} />
                    <!-- {supportEvent.getMatchingTags("amount")[0][1]}
                    {supportEvent.getMatchingTags("amount")[0][2]}
                    {supportEvent.tagValue("cadence")} -->
                    <!-- <UserCard ndk={$ndk} user={supportEvent.author} /> -->
                {/each}
            </Section>
        {/if}
    </div>
{/key}