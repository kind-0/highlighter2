<script lang="ts">
    import Section from "$components/Section.svelte";
    import { goto } from '$app/navigation';
    import { page } from '$app/stores';
    import { AvatarWithName, ndk, nicelyFormattedMilliSatNumber } from "@kind0/ui-common";
    import { NDKArticle, NDKEvent, zapInvoiceFromEvent, type NDKEventId, type NDKUser, type NDKZapInvoice, type Hexpubkey } from '@nostr-dev-kit/ndk';
    import ArticleContentCard from "$components/ContentCards/ArticleContentCard.svelte";
    import { derived, get, type Readable } from "svelte/store";
    import { userSubscription } from "$stores/user-view";
    import Reader from "$components/articles/reader.svelte";

    let { id } = $page.params;
    let { npub } = $page.data;
    let user: NDKUser;

    if (npub.startsWith('npub')) {
        user = $ndk.getUser({npub})
    }

    let articles: Readable<Map<NDKEventId, NDKArticle>>;
    let zaps: Map<Hexpubkey, number> = new Map();
    let zapPubkeys: Hexpubkey[];

    $: if (!articles && $userSubscription) {
        articles = derived(userSubscription, $userSubscription => {
            const articles = new Map<NDKEventId, NDKArticle>();

            for (const event of $userSubscription) {
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

{#if $articles}
    <Section
        title="Articles"
        on:click={() => { expanded = true; }}
        {expanded}
    >
        {#each $articles.values() as article (article.id)}
            <ArticleContentCard {article} />
        {/each}
    </Section>
{/if}