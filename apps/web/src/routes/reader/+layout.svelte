<script lang="ts">
    import PageContainer from '$components/PageContainer.svelte';
    import ReaderSidebar from '$components/sidebars/ReaderSidebar.svelte'
</script>

<PageContainer
    leftSidebar={ReaderSidebar}
>
    <slot />
</PageContainer>
