<script lang="ts">
    import { NDKArticle, type NDKTag } from "@nostr-dev-kit/ndk";
    import ArticleContentCard from "./ArticleContentCard.svelte";
    import { ndk } from "@kind0/lib-svelte-kit";
    import UrlContentCard from "./UrlContentCard.svelte";

    export let tag: NDKTag;
</script>

{#if tag[0] === "a"}
    {#await $ndk.fetchEvent(tag[1]) then article}
        {#if article}
            <ArticleContentCard article={NDKArticle.from(article)}  />
        {/if}
    {/await}
{:else if tag[0] === "r"}
    <UrlContentCard url={tag[1]} />
{/if}