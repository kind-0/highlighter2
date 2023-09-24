<script lang="ts">
    import { page } from "$app/stores";
    import { NDKArticle, NDKKind, NDKUser } from "@nostr-dev-kit/ndk";
    import { ndk } from "@kind0/ui-common";
    import { onDestroy, onMount } from "svelte";
    import type { NDKEventStore } from "@nostr-dev-kit/ndk-svelte";
    import Navbar from "$components/Navbar/Navbar.svelte";
    import Sidebar from "../Sidebar/Sidebar.svelte";
    import ArticleWideCard from "$components/articles/ArticleWideCard.svelte";

    const { npub } = $page.data;

    let user: NDKUser;
    let articles: NDKEventStore<NDKArticle> | undefined;

    onMount(() => {
        user = new NDKUser({npub});

        articles = $ndk.storeSubscribe({
            kinds: [NDKKind.Article as number],
            authors: [user.hexpubkey]
        }, undefined, NDKArticle);
    });

    onDestroy(() => {
        if (articles) articles.unsubscribe();
    });
</script>

{#if $articles}
    <div class="flex flex-col divide-y divide-base-300">
        {#each $articles as article (article.id)}
            <a href="/a/{article.encode()}" class="w-full">
                <ArticleWideCard
                    {article}
                    class="rounded-none min-h-[12rem] p-4"
                />
            </a>
        {/each}
    </div>
{/if}