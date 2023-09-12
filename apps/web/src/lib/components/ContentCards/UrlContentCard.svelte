<script lang="ts">
    import { onMount } from "svelte";
    import ContentCard from "./ContentCard.svelte";
    import { UrlIcon } from "@kind0/ui-common";

    export let url: string;

    let res: string | undefined;
    let siteName: string;

    onMount(async () => {
        try {
            const data = await fetch(`https://api.snort.social/api/v1/preview?url=${url}`, {
                "credentials": "omit",
                "headers": {
                    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:109.0) Gecko/20100101 Firefox/117.0",
                    "Accept": "application/json",
                    "Accept-Language": "en-US,en;q=0.5",
                    "Sec-Fetch-Dest": "empty",
                    "Sec-Fetch-Mode": "cors",
                    "Sec-Fetch-Site": "same-site",
                    "Sec-GPC": "1",
                    "Pragma": "no-cache",
                    "Cache-Control": "no-cache"
                },
                "referrer": "https://snort.social/",
                "method": "GET",
                "mode": "cors"
            });

            res = await data.json();
            // console.log({res})

            if (res?.og_tags && res?.og_tags.find((e: any) => e[0] === "og:site_name")) {
                siteName = res.og_tags.find((e: any) => e[0] === "og:site_name")[1];
            } else {
                siteName = new URL(url).hostname.replace("www.", "");
            }
        } catch (e) {
            console.log(`error`, e);
            res = undefined;
        }
    });
</script>

{#if res}
    <ContentCard
        title={res.title}
        summary={res.description}
        image={res.image}
        url={`/load?url=${encodeURIComponent(url)}`}
        class="truncate text-left items-start"
    >
        <UrlIcon slot="icon" class="text-base-100-content"/>
        <div slot="footer" class="truncate text-base-100-content items-start">
            {siteName}
        </div>
    </ContentCard>
{/if}