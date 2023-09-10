<script lang="ts">
    import NewContent from "$components/Curations/NewContent.svelte";
    import Section from "$components/Section.svelte";
    import { NDKDVMRequest, type NDKArticle, NDKUser, NDKKind } from "@nostr-dev-kit/ndk";
    import { fade } from "svelte/transition";
    import DvmRecommendations from "./DVMRecommendations.svelte";
    import { setNewArticlesFilters } from "$stores/articles";

    const userInterests = ['philosophy', 'seneca', 'stoicism', 'nostr'];

    setNewArticlesFilters(
        {},
        [{ kinds: [NDKKind.Article], "#t": userInterests }]
    );

    let newContentArticlesToRender: number;
    let newContentExpanded = false;
</script>

<div class="flex flex-col gap-8">
    <DvmRecommendations />

    <div transition:fade>
        <Section
            title="Highlighter Fresh"
            on:click={() => {
                newContentArticlesToRender += 10;
                newContentExpanded = !newContentExpanded;
            }}
            expanded={newContentExpanded}
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
                bind:articlesToRender={newContentArticlesToRender}
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