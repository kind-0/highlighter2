<script lang="ts">
    import { page } from "$app/stores";    
</script>

<div class="flex flex-col w-full gap-2">
    {#each [['Home', '/'], ['Reader', '/reader'], ['Highlights', '/highlights']].filter(({1:pageUrl}) => pageUrl === '/' ? true : !($page.url.pathname.split(`/`).includes(pageUrl.slice(1)))) as [drawerOptText, drawerOptLink]}
        <a href={`${drawerOptLink}`} class="flex flex-row w-full justify-center items-center gap-2">                  
            <p class="font-bold text-xl lowercase">
                {drawerOptText}
            </p>
        </a>
    {/each}
</div>