<script lang="ts">
    import ContentCard from "./ContentCard.svelte";
    import { UrlIcon } from "@kind0/ui-common";

    export let url: string;
    export let previewData: any;
    let siteName: string;

    if (previewData?.og_tags && previewData?.og_tags.find((e: any) => e[0] === "og:site_name")) {
        siteName = previewData.og_tags.find((e: any) => e[0] === "og:site_name")[1];
    } else {
        siteName = new URL(url).hostname.replace("www.", "");
    }
</script>

{#if previewData}
    <ContentCard
        title={previewData.title??siteName}
        summary={previewData.description}
        image={previewData.image}
        url={`/load?url=${encodeURIComponent(url)}`}
        class="truncate text-left items-start"
    >
        <UrlIcon slot="icon" class="text-base-100-content"/>
        <div slot="footer" class="truncate text-base-100-content items-start">
            {siteName}
        </div>
    </ContentCard>
{/if}