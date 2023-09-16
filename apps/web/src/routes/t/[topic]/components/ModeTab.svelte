<script lang="ts">
    import { page } from '$app/stores';

    let { topic } = $page.params;

    $: topic = $page.params.topic;
</script>

<div class="tabs tabs-boxed">
    <a
        href="/t/{topic}"
        class="tab"
        class:tab-active={$page.url.pathname === `/t/${topic}`}
    >All</a>
    <a
        href="/t/{topic}/articles"
        class="tab"
        class:tab-active={$page.url.pathname === `/t/${topic}/articles`}
    >Articles</a>
    <a
        href="/t/{topic}/highlights"
        class="tab"
        class:tab-active={$page.url.pathname === `/t/${topic}/highlights`}
    >Highlights</a>
    <a
        href="/t/{topic}/notes"
        class="tab"
        class:tab-active={$page.url.pathname === `/t/${topic}/notes`}
    >Margin Notes</a>
</div>

<style>
    .tabs.tabs-boxed .tab.tab-active {
        @apply bg-base-300;
    }
</style>