<script lang="ts">
    import { getUserSupportPlansStore, getUserSupporters } from "$stores/user-view";
    import { AttentionButton, Avatar, AvatarWithName, ModalWrapper, Name, PrimaryButton, ndk, nicelyFormattedMilliSatNumber, pay, user as currentUser } from "@kind0/ui-common";
    import { NDKEvent, type NDKUser, type NDKUserProfile, type NostrEvent } from "@nostr-dev-kit/ndk";
    import { onMount } from "svelte";
    import SupportCustomPlan from "./SupportCustomPlan.svelte";
    import { ArrowRight, Plus } from "phosphor-svelte";
    import SupportAuthorSuccess from "./SupportAuthorSuccess.svelte";

    export let user: NDKUser;

    let bitcoinPrice: number | undefined;
    let selectedValue: number;
    let paid = false;

    onMount(async () => {
        const response = await fetch("https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd");
        const data = await response.json();
        bitcoinPrice = data.bitcoin.usd;
    });

    let profile: NDKUserProfile | null;
    let modalTitle: string;

    const supportPlans = getUserSupportPlansStore();

    if (user) {
        modalTitle = `Support creator`;
        user.fetchProfile().then((p) => {
            profile = p;

            if (profile) {
                modalTitle = `Support ${profile.displayName}`;
            }
        });
    }

    async function support(plan?: NDKEvent) {
        if (!user) return;

        let amountInFiat: number;
        let amountInTag = plan?.tagValue("amount");

        if (amountInTag) {
            amountInFiat = parseInt(amountInTag);
        } else {
            amountInFiat = selectedValue;
        }

        const amountInSats = Math.round(amountInFiat / bitcoinPrice! * 100000000);

        const event = new NDKEvent($ndk, {
            kind: 7001,
            tags: [
                [ "amount", amountInFiat.toString(), "usd" ],
                [ "cadence", plan?.tagValue("cadence") ?? "month" ],
            ]
        } as NostrEvent);

        if (plan) {
            event.tag(plan, "plan");
        } else {
            event.tag(user);
        }

        await event.sign();

        const pr = await event.zap(amountInSats * 1000, "Highlighter Supporter", undefined, user);

        if (pr) {
            const payment = await pay(pr);

            if (payment) {
                await event.publish();
                paid = true;
            }
        }
    }

    const supporters = getUserSupporters();
</script>

<div class="relative">
        {#if profile?.banner}
            <div class="absolute -mt-8 left-0 h-[300px] w-full blur-md">
                <div class="relative h-[300px] w-full overflow-hidden">
                    <img src={profile?.banner} alt="Banner" class="absolute inset-0 w-full h-full object-cover banner">
                    <div class="absolute inset-x-0 bottom-0 h-[100%] bg-gradient-to-t from-base-200 to-transparent" />
                </div>
            </div>
        {/if}

        {#if !paid}
            <div class="flex flex-col gap-8 z-10 items-center">
                <div class="text-base-100-content text-xl flex flex-col items-center gap-2">
                    {#if $supporters.length > 1}
                        Join {$supporters.length} other people helping make
                        <span class="block text-2xl font-extrabold"><Name {user} />'s</span>
                        work possible.
                    {:else if $supporters.length === 1}
                        Join to help make
                        <span class="block text-2xl font-extrabold"><Name {user} />'s</span>
                        work possible.
                    {:else}
                        Become the first person helping make
                        <span class="block text-2xl font-extrabold"><Name {user} />'s</span>
                        work possible.
                    {/if}
                </div>

                <div class="flex flex-row flex-wrap avatar-group justify-center items-center gap-6">
                    <Avatar user={$currentUser} class="w-12 h-12 border-0" type="circle" />

                    {#if $supporters.length > 0}
                    <ArrowRight class="w-4 h-4 text-accent2" weight="bold" />
                        {#each $supporters as supporter (supporter.id)}
                            <Avatar user={supporter.author} class="w-12 h-12 border-0" type="circle" />
                        {/each}
                    {/if}
                </div>

                <div class="mx-auto">
                    {#if $supportPlans.length === 0}
                        <SupportCustomPlan {bitcoinPrice} bind:selectedValue on:click={() => support()} />
                    {/if}

                    {#each $supportPlans as plan (plan.id)}
                        <div class="card card-compact !bg-transparent/60 w-96">
                            <div class="card-body">
                                <PrimaryButton color="accent2" on:click={() => support(plan)}>
                                    Support with
                                    {nicelyFormattedMilliSatNumber(plan.tagValue("amount"))}
                                    / {plan.tagValue("cadence")}
                                </PrimaryButton>
                            </div>
                        </div>
                    {/each}
                </div>
            </div>
        {:else}
            <SupportAuthorSuccess
                supporters={$supporters}
                {user}
            />
        {/if}
    </div>

<style lang="postcss">
    .banner {
        filter: brightness(0.5);
        /* object-position: top; */
    }
</style>