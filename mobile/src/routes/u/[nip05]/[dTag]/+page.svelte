<script lang="ts">
    import { page } from '$app/stores';

    import Reader from '$lib/components/articles/reader.svelte';
    import MarkdownIt from 'markdown-it';
    import { NDKUser, type NDKEvent } from '@nostr-dev-kit/ndk';
    import { ndk } from "@kind0/ui-common";
    import NDKArticle from "@nostr-dev-kit/ndk";

    import Navbar from '$lib/components/Navbar/Navbar.svelte';
    import { onMount } from 'svelte';

    const {npub} = $page.data;
    const { dTag } = $page.params;

    const user = new NDKUser({npub});

    let article: NDKArticle;

    let articlePromise;

    onMount(() => {
        articlePromise = new Promise((resolve) => {
            $ndk.fetchEvent({
                kinds: [30023],
                authors: [user.hexpubkey],
                "#d": [dTag]
            }).then((e) => {
                if (!e) {
                    resolve(null);
                    alert('nope')
                    return;
                }

                article = NDKArticle.from(e);
                const md = new MarkdownIt();
                md.linkify?.set();
                unmarkedContent = md.render(article.content);
                content = unmarkedContent;

                resolve(article);
            });
        })
    });

    let loadedId: string;

    let content: string = '';
    let unmarkedContent: string = '';
</script>

<Navbar />

{#await articlePromise}
    <div class="full relative card">
        <div class="card-body">
            <!-- <Card class="text-center flex flex-row gap-4 items-center absolute z-50 md:p-8" style="top: 40%; left: 40%;">
                <h1 class="text-xl">
                    Loading article...
                </h1>
            </Card> -->

            <!-- <div  class="flex flex-col items-start">
                <TestimonialPlaceholder />
            </div>

            <Skeleton size='xxl' class='mt-8'/>
            <Skeleton size='xxl' class='mt-8'/>
            <Skeleton size='xxl' class='mt-8'/> -->
            Loading
            <div class="flex flex-col items-start">
                <div class="flex flex-row items-center gap-4">
                    <div class="w-8 h-8 rounded-full bg-base-200 animate-pulse"></div>
                    <div class="flex flex-col gap-2">
                        <div class="w-32 h-4 rounded-lg bg-base-200 animate-pulse"></div>
                        <div class="w-64 h-4 rounded-lg bg-base-200 animate-pulse"></div>
                    </div>
                </div>
                <div class="w-full h-4 rounded-lg bg-base-200 animate-pulse"></div>
                <div class="w-full h-4 rounded-lg bg-base-200 animate-pulse"></div>
                <div class="w-full h-4 rounded-lg bg-base-200 animate-pulse"></div>
                <div class="w-full h-4 rounded-lg bg-base-200 animate-pulse"></div>
                <div class="w-full h-4 rounded-lg bg-base-200 animate-pulse"></div>
                <div class="w-full h-4 rounded-lg bg-base-200 animate-pulse"></div>
                <div class="w-full h-4 rounded-lg bg-base-200 animate-pulse"></div>
                <div class="w-full h-4 rounded-lg bg-base-200 animate-pulse"></div>
            </div>
        </div>
    </div>
{:then article}
    {#if article}
        <Reader
            {article}
            {content}
            {unmarkedContent}
        />
    {/if}
{:catch}
    <Card size="full">
        <div class="text-center">
            <h1>Article not found</h1>
            <p>Unable to find article with id {naddr}</p>
        </div>
    </Card>
{/await}
