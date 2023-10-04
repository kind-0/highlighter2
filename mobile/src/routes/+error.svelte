<script lang="ts">
    import HomePageLink from "$components/HomePageLink.svelte";

    //

    let errorMsg = `page route error.`
</script>

<div class="flex flex-col h-screen w-full justify-between items-center p-12">
    <div class="flex flex-col">
        <div class="flex flex-row w-full justify-center items-center">
            <p class="font-sans font-medium text-base">
                {`error: ${errorMsg}`}
            </p>
        </div>
        <HomePageLink />
    </div>

    <a href="/" class="flex flex-row w-full justify-center items-center pt-4">
        <p class="font-sans font-light text-base">
            {`highlighter`}
        </p>
    </a>
</div>