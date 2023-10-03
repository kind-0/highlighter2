<script lang="ts">
    import { AttentionButton } from "@kind0/ui-common";

    export let loading = false
</script>

<AttentionButton on:click {loading}
    class="tracking-wider {$$props.class??''}"
>
    <slot />
</AttentionButton>