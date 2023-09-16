<script lang="ts">
    import Hashtag from "$icons/Hashtag.svelte";
    import { userFollowHashtags, userInterestLists } from "$stores/session";
    import { MenuItem } from "@kind0/ui-common";

    let filteredFollowedHashtags: string[] = [];

    $: if ($userFollowHashtags) {
        const interestListsTags = $userInterestLists
            .map(list => list.getMatchingTags("t").map(tag => tag[1]))
            .flat();

        filteredFollowedHashtags = $userFollowHashtags
            .filter(hashtag => !interestListsTags.includes(hashtag));
    }
</script>

{#if $userInterestLists.length > 0 || ($userFollowHashtags && $userFollowHashtags.length > 0)}
    <li class="menu-title">TOPICS</li>

    {#each $userInterestLists as interestList}
        <MenuItem
            href="/t/{interestList.encode()}"
            activeClass="border-l-accent"
            innerClass="flex flex-row gap-2"
        >
            <Hashtag class="w-6 h-6 !text-base-300-content" />
            {interestList.name}
        </MenuItem>
    {/each}
    {#each filteredFollowedHashtags as hashtag}
        <MenuItem
            href="/search?q={encodeURIComponent(hashtag)}"
            activeClass="border-l-accent"
            innerClass="flex flex-row gap-2"
        >
            <Hashtag class="w-6 h-6 !text-base-300-content" />
            {hashtag}
        </MenuItem>
    {/each}
{/if}