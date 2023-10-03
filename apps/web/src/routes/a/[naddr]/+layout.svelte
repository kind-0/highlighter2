<script lang="ts">
    import PageContainer from '$components/PageContainer.svelte';
    import { page_loading } from '$stores/page_loading';
</script>

<PageContainer pageContainerClass={`overflow-y-hidden`} pageOverflowHidden={true} pageLoading={$page_loading}>
    <slot />
</PageContainer>
