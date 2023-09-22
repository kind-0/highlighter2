<!--
    This component shows lists of popular lists
-->
<script lang="ts">
    import MenuItem from "../sidebars/MenuItem.svelte";
    import { NDKKind, NDKList } from "@nostr-dev-kit/ndk";
    import { ndk } from "@kind0/ui-common";
    import { Name } from "@nostr-dev-kit/ndk-svelte-components";

    const lists = $ndk.storeSubscribe({
        kinds: [NDKKind.CategorizedHighlightList as number],
    }, undefined, NDKList);
</script>

{#if $lists?.length > 1}
    <ul class="menu bg-base-200 w-full rounded-box">
        <li class="menu-title">POPULAR LISTS</li>

        {#each $lists as item}
            <MenuItem href={`/highlights/a/${item.encode()}`}>
                <Name ndk={$ndk} user={item.author} />'s
                {item.name}
            </MenuItem>
        {/each}
    </ul>
{/if}