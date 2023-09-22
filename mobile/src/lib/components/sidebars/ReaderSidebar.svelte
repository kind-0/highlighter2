<script>
    import ReaderIcon from '$icons/ReaderIcon.svelte';
    import CardWithTitle from '$components/cards/CardWithTitle.svelte';
    import {HighlightIcon, SidebarSectionLink} from '@kind0/ui-common';
    import InterestMenuItems from './InterestMenuItems.svelte';
    import { ArrowArcRight } from 'phosphor-svelte';
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
        href="/reader"
    >
        <ul class="menu bg-base-200 w-full rounded-box">
            <li class="menu-title">CURATIONS</li>

            <li>
                <a>
                    <ArrowArcRight />
                    Explore
                </a>
            </li>

            <InterestMenuItems />
        </ul>
    </CardWithTitle>
</div>