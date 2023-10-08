<script lang="ts">
	import { NDKDVMJobResult, NDKKind } from '@nostr-dev-kit/ndk';
    import Reader from '$lib/components/articles/reader.svelte';

    import { page } from '$app/stores';
    import MarkdownIt from 'markdown-it';
    import type { NDKEvent } from '@nostr-dev-kit/ndk';
    import { ndk } from "@kind0/ui-common";
    import {NDKArticle} from "@nostr-dev-kit/ndk";
    import ReaderDVMTranscriptionHeader from '$lib/components/articles/dvm/ReaderDVMTranscriptionHeader.svelte';

    import ZapEventCard from '$lib/components/zaps/ZapEventCard.svelte';
    import EventCard from '$lib/components/events/generic/card.svelte';
    import { page_loading } from '$stores/page_loading';

    const { naddr } = $page.params;
    let article: NDKEvent | NDKArticle;
    let articlePromise: Promise<NDKEvent | NDKArticle | null> | undefined;

    let loadedId: string;

    let content: string = '';
    let unmarkedContent: string = '';

    $: if (naddr !== loadedId) {
        loadedId = naddr;
        try {
            articlePromise = new Promise(async (resolve, reject) => {
                const e = await $ndk.fetchEvent(naddr);
                if (!e) return reject("Unable to fetch event");

                if (e.kind === NDKKind.Article) {
                    article = NDKArticle.from(e);
                    const md = new MarkdownIt({
                        html: true,
                        linkify: true,
                        typographer: true,
                    });
                    md.linkify.set();
                    unmarkedContent = md.render(article.content);
                    content = unmarkedContent;
                } else {
                    article = e;

                    content = article.content;
                    unmarkedContent = article.content;
                }
                resolve(article);
            });
        } catch (e) {
            console.error(`layout error`, e);
        }
    }

    function shouldRenderAsHtml()  {
        if (article?.kind === 1) {
            return false;
        }

        return true;
    }

    $: {
        if(!!articlePromise) {
            page_loading.set(false)
        }
    }
</script>

{#await articlePromise}
    <div />
{:then article}
    {#if !article}
        No article found
    {:else if article.kind === 9735}
        <Reader {article} {unmarkedContent}>
            <ZapEventCard draggable={false} event={article} skipFooter={false}  />
        </Reader>
    {:else if article.kind === 31337}
        <EventCard draggable={false} event={article} skipFooter={false}  />
    {:else if article.kind === NDKKind.DVMJobResult}
        <Reader
            {article}
            {content}
            {unmarkedContent}
            renderAsHtml={shouldRenderAsHtml()}
        >
            <div slot="preArticle">
                <ReaderDVMTranscriptionHeader jobResult={NDKDVMJobResult.from(article)} />
            </div>
        </Reader>
    {:else}
        <Reader
            {article}
            {content}
            {unmarkedContent}
            renderAsHtml={shouldRenderAsHtml()}
        />
    {/if}
{:catch}
    <div class="card">
        <div class="card-body">
            <h1>Article not found</h1>
            <p>Unable to find article with id {naddr}</p>
        </div>
    </div>
{/await}
