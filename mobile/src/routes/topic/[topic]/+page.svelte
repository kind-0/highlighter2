<script lang="ts">
    import { page } from "$app/stores";
    import Navbar from '$lib/components/Navbar/Navbar.svelte';
    import Sidebar from "$components/sidebars/ReaderSidebar.svelte";
    import { ThreeColumnsLayout, ndk } from "@kind0/ui-common";
    import MixedContent from "$components/MixedContent.svelte";

    let topic: string;

    $: topic = $page.params.topic;
</script>

<ThreeColumnsLayout>
    <div slot="navbar">
        <Navbar />
    </div>

    <div slot="sidebar">
        <Sidebar />
    </div>

    {#key topic}
        <MixedContent
            title={`#${topic}`}
            topics={[topic]}
        />
    {/key}
</ThreeColumnsLayout>
