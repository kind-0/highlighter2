<script lang="ts">
    import { AvatarWithName, LongFormIcon } from "@kind0/ui-common";
    import type { NDKArticle } from "@nostr-dev-kit/ndk";
    import ContentCard from "./ContentCard.svelte";

    export let article: NDKArticle;
    export let skipAuthor = false;
</script>

{#if !article}
    Invalid article
{:else}
    <ContentCard
        title={article.title}
        summary={article.tagValue("summary")}
        image={article.image}
        url={`/a/${article.encode()}`}
        event={article}
        class="truncate text-left items-start"
    >
        <LongFormIcon slot="icon" class="w-7 h-7" />
        <a href="/p/{article.author.npub}" slot="footer">
            {#if !skipAuthor}
                <AvatarWithName
                    pubkey={article.pubkey}
                    avatarClass="w-7 h-7 rounded-md"
                    nameClass="text-base-100-content items-start" />
            {/if}
        </a>
    </ContentCard>
{/if}