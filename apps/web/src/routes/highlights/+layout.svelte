<script lang="ts">
    import PageContainer from "$components/PageContainer.svelte";
    import HighlightsSidebar from "$components/sidebars/HighlightsSidebar.svelte";
</script>

<PageContainer
    leftSidebar={HighlightsSidebar}
>
    <slot />
</PageContainer>
