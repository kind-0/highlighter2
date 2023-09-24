<script lang="ts">
    import { page } from "$app/stores";
    import { ndk } from "@kind0/ui-common";
    import { NDKList } from "@nostr-dev-kit/ndk";
    import MixedContent from "../../../lib/components/MixedContent.svelte";

    let naddr: string = $page.params.naddr;
    const authors: string[] = [];
    let topics: string[] = [];

    const promise = new Promise<NDKList>((resolve, reject) => {
        $ndk.fetchEvent(naddr).then(event => {
            if (!event) {
                return reject(`Unable to find event ${naddr}`)
            }

            const list = NDKList.from(event);

            for (const topic of list.getMatchingTags("t")) { topics.push(topic[1]); }
            // for (const pubkey of list.getMatchingTags("p")) { authors.push(pubkey[1]); }

            resolve(list);
        }).catch(reject);
    });

</script>

{#await promise}
    Loading {naddr}
{:then event}
    <MixedContent
        title={event.name??"List"}
        {topics}
    />


{/await}