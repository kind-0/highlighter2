<script lang="ts">
    import { page } from '$app/stores';
    import { user, userFollows } from '$stores/session';
    import MainWithRightSidebar from '$lib/layouts/MainWithRightSidebar.svelte';

    let fetchScopePromise: Promise<void> | undefined = undefined;
    let scope: string | undefined = undefined;

    $: scope = $page.params.scope;
</script>

<MainWithRightSidebar>
    {#if scope === 'network'}
        {#if $userFollows === undefined}
            <slot />
        {:else}
            <slot />
        {/if}
    {:else if fetchScopePromise}
        {#await fetchScopePromise}
            Loading scope
        {:then}
            <!-- <PageTitle
                title={$currentScope.label}
                subtitle={list?.description}
            /> -->

            <slot />
        {/await}
    {:else}
        <slot />
    {/if}

    <!-- <div slot="right-sidebar">
        <div class="flex flex-col items-center gap-8">
            <ul class="menu bg-base-200 w-full rounded-box">
                <li class="menu-title">TOPICS</li>

                <MenuItem href="/highlights/t/bitcoin">
                    <img src="https://abs.twimg.com/hashflags/Bitcoin_evergreen/Bitcoin_evergreen.png" style="width: 1.2em; vertical-align: -20%; margin-right: 0.075em; height: 1.2em; margin-left: 2px; display: inline-block;">
                    Bitcoin
                </MenuItem>

                <MenuItem href="/highlights/t/ai">
                    Artificial Intelligence
                </MenuItem>

                <MenuItem href="/highlights/t/regenerative-agriculture">
                    Regenerative Agriculture
                </MenuItem>
            </ul>

            <PopularShelves />
        </div>
    </div> -->
</MainWithRightSidebar>

