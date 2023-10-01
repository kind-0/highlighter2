<script lang="ts">
    import { AttentionButton } from "@kind0/ui-common";
</script>

<AttentionButton on:click
    class="tracking-wider {$$props.class??''}"
>
    <slot />
</AttentionButton>