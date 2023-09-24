<script lang="ts">
    import { page } from '$app/stores';
    import { fetchArticle } from '$lib/article';
    import Navbar from '$lib/components/Navbar/Navbar.svelte';
    import Reader from '$lib/components/articles/reader.svelte';
    import { NDKUser, type Hexpubkey } from '@nostr-dev-kit/ndk';

    export let data;
    const { text, contentType, title, articleUrl } = data;

    let url: string;
    let author: string;

    $: {
        url = $page.url.searchParams.get('url') || '';
        author = $page.url.searchParams.get('author') || '';

        if (url.startsWith('https://highlighter.com/load?url=')) {
            url = decodeURIComponent(url.replace('https://highlighter.com/load?url=', '') || '');
        }
    }

    let authorHexpubkey: Hexpubkey | undefined;

    $: {
        if (author && authorHexpubkey === undefined) {
            try {
                if (author.startsWith('npub')) {
                    authorHexpubkey = (new NDKUser({npub: author})).hexpubkey;
                } else {
                    authorHexpubkey = author;
                }
            } catch(e) {}
        }
    }
</script>

<Navbar />

{#if text}
    {#if contentType === 'text/plain'}
        <Reader
            article={url}
            content={text.replace(/  /g, ' ')}
            unmarkedContent={text.replace(/  /g, ' ')}
            url={url}
        />
    {:else if contentType === 'embed/overcast'}
        overcast
    {:else if contentType === 'text/rss'}
        <Reader
            renderAsHtml={true}
            article={{
                title,
                url: articleUrl
            }}
            content={text}
            unmarkedContent={text}
            url={articleUrl}
        />
    {:else}
        {#await fetchArticle(text, url, contentType)}
            <div class="card">
                <div class="card-body">
                    Loading {url}
                </div>
            </div>
        {:then article}
            {#if article}
                <Reader
                    renderAsHtml={true}
                    {article}
                    content={article.content||""}
                    unmarkedContent={article.content||""}
                    url={article.url}
                />
            {:else}
                <p>Article not found</p>
            {/if}
        {:catch error}
            <div class="card">
                <div class="card-body">
                    {error.message}
                </div>
            </div>
        {/await}
    {/if}
{/if}