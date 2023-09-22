<script lang="ts">
    import { NDKDVMRequest, type NDKArticle, NDKUser, NDKKind } from "@nostr-dev-kit/ndk";
    import DvmRecommendations from "./DVMRecommendations.svelte";
    import { setNewArticlesFilters } from "$stores/articles";
    import RecentlyHighlighted from "./RecentlyHighlighted.svelte";
    import { userFollowHashtags } from "$stores/session";
    import NewArticles from "./NewArticles.svelte";

    const userInterests = $userFollowHashtags;

    setNewArticlesFilters(
        {},
        [{ kinds: [NDKKind.Article], "#t": userInterests }]
    );
</script>

<div class="flex flex-col gap-8">
    <DvmRecommendations />

    <RecentlyHighlighted />

    <NewArticles />
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