<script lang="ts">
    import RecentlyCurated from "$components/Curations/RecentlyCurated.svelte";
    import NewContent from "$components/Curations/NewContent.svelte";
    import Section from "$components/Section.svelte";
    import { NDKDVMRequest, type NDKArticle, NDKUser, NDKKind } from "@nostr-dev-kit/ndk";
    import { fade } from "svelte/transition";
    import { loadingScreen, networkFollows } from "$stores/session";
    import { onMount } from "svelte";
    import { ndk } from "@kind0/lib-svelte-kit";
    import DvmRecommendations from "./DVMRecommendations.svelte";
    import { setNewArticlesFilters } from "$stores/articles";

    const userInterests = ['philosophy', 'seneca', 'stoicism', 'nostr'];

    setNewArticlesFilters(
        {},
        [{ kinds: [NDKKind.Article], "#t": userInterests }]
    );

    let renderNewContent = false;
    let newContentItems: NDKArticle[];
    let newContentArticlesToRender: number;
    let newContentExpanded = false;

    function newContentEose() {
        renderNewContent = renderNewContent || (
            newContentItems?.length >= newContentArticlesToRender
        );

        if (renderNewContent) {
            $loadingScreen = false;
        }
    }

    onMount(() => {
        newContentEose();
    })
</script>

<div class="flex flex-col gap-8">
    <DvmRecommendations />

    <div transition:fade>
        <Section
            title="Highlighter Fresh"
        >
            <div slot="actions">
                <button class="btn btn-ghost font-light"
                    on:click={() => {
                        newContentArticlesToRender += 10;
                        newContentExpanded = !newContentExpanded;
                    }}
                >
                    View
                    {#if newContentExpanded}
                        Less
                    {:else}
                        More
                    {/if}
                </button>
            </div>
            <NewContent
                bind:items={newContentItems}
                bind:articlesToRender={newContentArticlesToRender}
                on:ready={newContentEose}
                expanded={newContentExpanded}
            />
        </Section>
    </div>
<!--
    <Section
        title="Recently Curated"
    >
        <RecentlyCurated />
    </Section>

    <Section
        title="Popular Content"
    >
        <RecentlyCurated />
    </Section> -->
</div>