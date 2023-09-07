<script lang="ts">
    import { NDKHighlight } from "@nostr-dev-kit/ndk";
    import HighlightContent from "./HighlightContent.svelte";

    export let highlight: NDKHighlight;
</script>

<HighlightContent
    {highlight}
/>