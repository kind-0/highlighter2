<script lang="ts">
  import { safeAreaTop } from "$lib/store/design";
  import "../app.css";
</script>

<div
  class="flex flex-col h-screen w-screen justify-start items-start overflow-y-scroll overflow-x-hidden
  {$safeAreaTop ? `pt-12` : ``}"
>
  <slot />
</div>
