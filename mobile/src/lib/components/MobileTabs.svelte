<script lang="ts">
    import { page_layout } from "$stores/page_layout";

    $: addMobileTopSpace = $page_layout === `mobile_addtopspace`
</script>

<div class="hidden max-lg:block fixed z-10 left-0 bottom-0 flex-row h-auto w-full justify-start items-start {addMobileTopSpace ? `py-2` : `pb-0`} bg-base-200 border-t-base-300 border-t-[1.5px]">
    <div class="flex flex-row h-mobileTabs w-full items-center gap-4 text-neutral/80">
        <div class="flex basis-1/4 justify-center active:scale-[97%]">
            <a href={`/reader`} class="flex flex-col w-full items-center gap-1">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6A2.25 2.25 0 016 3.75h2.25A2.25 2.25 0 0110.5 6v2.25a2.25 2.25 0 01-2.25 2.25H6a2.25 2.25 0 01-2.25-2.25V6zM3.75 15.75A2.25 2.25 0 016 13.5h2.25a2.25 2.25 0 012.25 2.25V18a2.25 2.25 0 01-2.25 2.25H6A2.25 2.25 0 013.75 18v-2.25zM13.5 6a2.25 2.25 0 012.25-2.25H18A2.25 2.25 0 0120.25 6v2.25A2.25 2.25 0 0118 10.5h-2.25a2.25 2.25 0 01-2.25-2.25V6zM13.5 15.75a2.25 2.25 0 012.25-2.25H18a2.25 2.25 0 012.25 2.25V18A2.25 2.25 0 0118 20.25h-2.25A2.25 2.25 0 0113.5 18v-2.25z" />
                  </svg>                                                          
                <p class="font-sans text-[10px]">
                    {`Reader`}
                </p>
            </a>
        </div>
        <div class="flex basis-1/4 justify-center active:scale-[97%]">
            <a href={`/highlights`} class="flex flex-col w-full items-center gap-1">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 5.25h16.5m-16.5 4.5h16.5m-16.5 4.5h16.5m-16.5 4.5h16.5" />
                  </svg>                                 
                <p class="font-sans text-[10px]">
                    {`Highlights`}
                </p>
            </a>
        </div>  
        <div class="flex basis-1/4 justify-center active:scale-[97%]">
            <a href={`/search`} class="flex flex-col w-full items-center gap-1">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M21 21l-5.197-5.197m0 0A7.5 7.5 0 105.196 5.196a7.5 7.5 0 0010.607 10.607z" />
                </svg>
                <p class="font-sans text-[10px]">
                    {`Search`}
                </p>
            </a>
        </div>  
        <div class="flex basis-1/4 justify-center active:scale-[97%]">
            <a href={`/profile`} class="flex flex-col w-full items-center gap-1">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M17.982 18.725A7.488 7.488 0 0012 15.75a7.488 7.488 0 00-5.982 2.975m11.963 0a9 9 0 10-11.963 0m11.963 0A8.966 8.966 0 0112 21a8.966 8.966 0 01-5.982-2.275M15 9.75a3 3 0 11-6 0 3 3 0 016 0z" />
                </svg>
                <p class="font-sans text-[10px]">
                    {`Profile`}
                </p>
            </a>
        </div>                
    </div>
</div>