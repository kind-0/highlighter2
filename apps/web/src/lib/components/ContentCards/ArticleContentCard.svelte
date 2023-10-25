<script lang="ts">
    import { AvatarWithName, LongFormIcon } from "@kind0/ui-common";
    import type { NDKArticle } from "@nostr-dev-kit/ndk";
    import ContentCard from "./ContentCard.svelte";
    import { createEventDispatcher } from "svelte";

    export let article: NDKArticle;
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
            <AvatarWithName
                pubkey={article.pubkey}
                avatarClass="w-7 h-7 rounded-md"
                nameClass="text-base-100-content items-start" />
        </a>
    </ContentCard>
{/if}