<script lang="ts">
    import { NDKDVMRequest, type NDKArticle, NDKUser, NDKKind, type NDKFilter } from "@nostr-dev-kit/ndk";
    import DvmRecommendations from "./DVMRecommendations.svelte";
    import { newArticles, setNewArticlesFilters } from "$stores/articles";
    import RecentlyHighlighted from "./RecentlyHighlighted.svelte";
    import { userFollowHashtags, loadingScreen } from "$stores/session";
    import NewArticles from "./NewArticles.svelte";
    import { onDestroy, onMount } from "svelte";
    import { page } from "$app/stores";

    const userInterests = $userFollowHashtags;

    let rss: string;

    $: rss = $page.url.searchParams.get("rss");

    onMount(() => {
        const filter: NDKFilter = { kinds: [NDKKind.Article], limit: 20 };

        if (userInterests?.length > 0) {
            filter["#t"] = userInterests;
        }

        newArticles.ref();

        setNewArticlesFilters(
            {},
            [filter]
        );
    });

    onDestroy(() => {
        newArticles.unref();
    })
</script>

<div class="flex flex-col max-lg:w-screen overflow-x-hidden gap-8">
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