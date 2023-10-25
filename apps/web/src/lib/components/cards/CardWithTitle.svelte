<script lang="ts">
    export let icon: any | undefined = undefined;
    export let title: string | undefined = undefined;
    export let href: string = "#";
</script>

<div class="bg-base-200 w-full rounded-box py-2">
    <div class="
        border-b border-base-300 px-6 pt-2 pb-4
    ">
        <a {href} class="flex flex-row gap-5 items-center hover:!bg-transparent">
            {#if icon}
                <svelte:component this={icon} class={$$props.iconClass ?? "w-5 h-5"} />
            {:else if $$slots.icon}
                <slot name="icon" />
            {/if}

            <div class="text-base-100-content truncate">
                {#if $$slots.title}
                    <slot name="title" />
                {:else}
                    {title}
                {/if}
            </div>
        </a>
    </div>

    <slot />
</div>