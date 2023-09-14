<script lang="ts">
    import { NDKHighlight } from "@nostr-dev-kit/ndk";
    import { AvatarWithName, Favicon } from "@kind0/ui-common";
    import linkToArticle from './link-to-article.js';
    import { Avatar } from "@kind0/ui-common";
    import { NDKEvent, type NDKUser, NDKArticle } from "@nostr-dev-kit/ndk";

    export let highlight: NDKHighlight;

    let author: NDKUser;
    let title: string | undefined = highlight.tagValue('title');

    if (!title && highlight.url) {
        try {
            title = new URL(highlight.url).hostname;
        } catch (e) {}
    }

    const getArticle = new Promise((resolve, reject) => {
        highlight.getArticle().then(a => {
            if (a instanceof NDKEvent) author = a.author;
            if (a instanceof NDKArticle) title ??= a?.title;
            resolve(a);
        }).catch(e => {
            reject(e);
        });
    });
</script>

{#await getArticle then article}
    <div class="text-lg font-regular truncate text-base-100-content">
        {#if article instanceof NDKArticle && article.title}
            <div class="flex flex-row items-center gap-2">
                <Avatar user={author} size="small" type="square" />
                <a href={linkToArticle(highlight)}>{title}</a>
            </div>
        {:else if highlight?.url && highlight.url.match(/^http(s)?:\/\//)}
            <div class="flex flex-row items-center gap-2">
                <Favicon url={highlight.url} class="w-8 h-8 rounded-md" />
                <a href={linkToArticle(highlight)}>{title}</a>
            </div>
        {:else if author}
            <a href={linkToArticle(highlight)} class="flex flex-row gap-2 items-center">Note <AvatarWithName pubkey={author.hexpubkey} avatarClass="w-10 h-10" /></a>
        {:else if typeof article === 'string'}
            <a class="" href={linkToArticle(highlight)}>{article}</a>
        {:else if !article}
            Unknown article
        {/if}
    </div>
{/await}