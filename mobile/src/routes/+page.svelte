<script lang="ts">
  import { teststore } from "@highlighter/svelte-kit-lib";

  let routes = [`following`, `your-highlights`];
</script>

<div class="flex flex-col w-full justify-center items-start p-8 space-y-4">
  <p class="font-sans font-bold text-3xl">
    {`Routes:`}
  </p>
  <div class="flex flex-col w-full justify-center items-center space-y-2">
    {#each routes as route}
      <div class="flex flex-row w-full justify-start items-center">
        <a href={`/${route}`}>
          <p class="font-sans font-medium text-2xl">
            {`- ${route}`}
          </p>
        </a>
      </div>
    {/each}
  </div>
  <button
    class="btn"
    on:click={() => {
      teststore.set(!$teststore);
    }}
  >
    tap teststore
  </button>

  <p>
    {`teststore is: ${$teststore}`}
  </p>
</div>
