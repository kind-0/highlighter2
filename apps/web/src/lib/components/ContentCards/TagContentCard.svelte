<script lang="ts">
    import { NDKArticle, type NDKTag } from "@nostr-dev-kit/ndk";
    import ArticleContentCard from "./ArticleContentCard.svelte";
    import { ndk } from "@kind0/ui-common";
    import UrlContentCard from "./UrlContentCard.svelte";
    import { createEventDispatcher } from "svelte";
    import rejectEvent from "$components/jobs/status/reject";

    const dispatch = createEventDispatcher();

    export let tag: NDKTag;

    let article: NDKArticle;
    let previewData: any;

    const load = new Promise<void>((resolve, reject) => {
        if (tag[0] === "a") {
            $ndk.fetchEvent(tag[1]).then((event) => {
                if (!event) { reject(); return; }
                article = NDKArticle.from(event);
                dispatch("loaded", { article });
                resolve();
            });
        } else if (tag[0] === "r") {
            try {
                fetch(`https://api.snort.social/api/v1/preview?url=${tag[1]}`, {
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
                }).then((res) => {
                    if (res.status > 299) {
                        reject(`status ${res.status}`);
                        return;
                    }

                    return res.json();
                }).then((res) => {
                    if (!res) { reject(); return; }
                    dispatch("loaded", { previewData: res });
                    previewData = res;
                    resolve();
                });
            } catch (e) {

            }
        }
    })
</script>

{#await load then payload}
    {#if tag[0] === "a"}
        <ArticleContentCard {article} />
    {:else if tag[0] === "r"}
        <UrlContentCard url={tag[1]} {previewData} />
    {:else}
        <p>Unknown tag type: {JSON.stringify(tag)}</p>
    {/if}
{:catch e}
    <!-- <p>Unable to load {JSON.stringify(tag)}: {e}</p> -->
{/await}