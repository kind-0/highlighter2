<script lang="ts">
    import { page } from "$app/stores";
    import { NDKArticle, NDKKind, NDKUser, type NDKEventId } from "@nostr-dev-kit/ndk";
    import { ndk } from "@kind0/ui-common";
    import { onDestroy, onMount } from "svelte";
    import type { NDKEventStore } from "@nostr-dev-kit/ndk-svelte";
    import Navbar from "$components/Navbar/Navbar.svelte";
    import Sidebar from "../Sidebar/Sidebar.svelte";
    import ArticleWideCard from "$components/articles/ArticleWideCard.svelte";
    import { userSubscription } from "$stores/user-view";
    import { derived, type Readable } from "svelte/store";

    const { npub } = $page.data;
    let user: NDKUser;

    if (npub.startsWith('npub')) {
        try {
            user = $ndk.getUser({npub})
        } catch(e) {
            console.log(e, ` error`);
        }
    }


    let articles: Readable<NDKArticle[]>;

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

            return Array.from(articles.values())
                .sort((a, b) => (b.published_at||b.created_at)! - (a.published_at||a.created_at)!);
        });
    }
</script>

{#if $articles}
    <div class="flex flex-col divide-y divide-base-300">
        {#each $articles.values() as article (article.id)}
            <a href="/a/{article.encode()}" class="w-full">
                <ArticleWideCard
                    {article}
                    class="rounded-none min-h-[12rem] p-4"
                />
            </a>
        {/each}
    </div>
{/if}