<script lang="ts">
    import { page_drawer } from "$stores/page_drawer";
    import DrawerInnerContainer from "./DrawerInnerContainer.svelte";

    export let onChange = async () => {return}
    export let pageOverflowHidden = false
</script>

<div class="drawer">
    <input
      id="my-drawer"
      type="checkbox"
      class="drawer-toggle"
      checked={$page_drawer}
      on:change={async () => {
        await onChange()
        page_drawer.set(!page_drawer)
      }}
    />
    <div class="drawer-content">
      <div class="flex flex-col h-auto w-full justify-center items-center {pageOverflowHidden ? `overflow-y-hidden` : ``}">
          <slot name="page" />
      </div>
    </div>
    <div class="drawer-side z-50">
      <label for="my-drawer" class="drawer-overlay" />
      <DrawerInnerContainer closeDrawerCallback={async () => { page_drawer.set(false) }}>
        <slot name="drawer" />
      </DrawerInnerContainer>
    </div>
  </div>