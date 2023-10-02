<script lang="ts">
    import PageContainer from '$components/PageContainer.svelte';
    import { page_loading } from '$stores/page_loading';
    import { onMount } from 'svelte';

    onMount(() => {
        page_loading.set(true)
    })
</script>

<PageContainer hideNavbar={true} pageContainerClass={`overflow-y-hidden`} pageOverflowHidden={true} pageLoading={$page_loading}>
    <slot />
</PageContainer>
