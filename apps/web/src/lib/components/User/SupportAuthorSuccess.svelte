<script lang="ts">
    import { user as currentUser } from "@kind0/ui-common";
    import { Avatar, Name, ZapSentIcon } from "@kind0/ui-common";
    import type { NDKEvent, NDKUser } from "@nostr-dev-kit/ndk";
    export let supporters: NDKEvent[];
    export let user: NDKUser;

    const isNwcActive = false;
</script>

<div class="flex flex-col gap-8 z-10 items-center">
    <div class="text-base-100-content text-xl flex flex-col items-center gap-2">
        You are now helping make
        <span class="block text-2xl font-extrabold"><Name {user} />'s</span>
        work possible.
    </div>

    <div class="flex flex-row flex-wrap avatar-group justify-center items-center gap-6">
        {#each supporters as supporter (supporter.id)}
            <Avatar user={supporter.author} class="w-12 h-12 border-0" type="circle" />
        {/each}

        <Avatar user={$currentUser} class="w-12 h-12 border-0" type="circle" />
    </div>
</div>

<div class="h-[300px] relative z-50">
    <ZapSentIcon class="h-[267px] w-full z-50" />
</div>


<bc-button app-name="Highlighter" />
