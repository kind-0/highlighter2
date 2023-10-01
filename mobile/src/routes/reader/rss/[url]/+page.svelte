<script lang="ts">
    import GenericWideCard from '$components/ContentWideCard/GenericWideCard.svelte';
    import Section from "$components/Section.svelte";
	import { PageTitle } from '@kind0/ui-common';
    import { page } from '$app/stores';
    export let data;

    const url = $page.params.url;

    const articles = data.items.map((item) => {
        return {
            title: item.title,
            published_at: item.pubDate,
            summary: item.contentSnippet.slice(0, 150),
            image: item.enclosure?.url,
            content: item.content,
            url: item.link,
        }
    });
</script>

<Section
    title={data.title}
    expanded={true}
    flow="column"
    class="divide-y-2 divide-base-300 rounded-box !gap-0"
>
    {#each articles as article, i (i)}
        <a href="/load?rss={url}&itemUrl={encodeURIComponent(article.url)}" class="py-4 w-full">
            <GenericWideCard
                title={article.title}
                summary={article.summary}
                image={article.image}
                date={article.published_at}
                class="w-full py-4"
                imageClass="rounded-lg"
                titleClass="!text-2xl"
            />
        </a>
    {/each}
</Section>
