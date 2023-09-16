<script>
    import ReaderIcon from '$icons/ReaderIcon.svelte';
    import CardWithTitle from '$components/cards/CardWithTitle.svelte';
    import {HighlightIcon, SidebarSectionLink} from '@kind0/ui-common';
</script>

<div class="flex flex-col gap-8">
    <SidebarSectionLink
        href="/highlights"
        title="Highlighter"
    >
        <span slot="icon"><HighlightIcon class="w-5 h-5 text-accent" /></span>
    </SidebarSectionLink>

    <CardWithTitle
        icon={ReaderIcon}
        title="Reader"
    >
        <ul class="menu bg-base-200 w-full rounded-box">
        </ul>
    </CardWithTitle>
</div>