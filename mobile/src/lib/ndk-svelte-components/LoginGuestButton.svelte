<script lang="ts">
    import { user, userFollows } from '$stores/session';
    import { loginAsGuest } from '@kind0/ui-common';
    import KeyIcon from '$lib/icons/Key.svelte';
    import AttentionButton from '$lib/components/buttons/AttentionButton.svelte';

    const names = [
        "Curious Reader",
        "The Eager Explorer",
        "A Thoughtful Thinker",
        "The Avid Annotator",
        "A Voracious Viewer",
        "The Inquisitive Intellect",
        "A Knowledge Knight",
        "The Pensive PageTurner",
        "A Reflective Reader",
        "The Scholarly Seeker",
        "A Wise Wanderer",
        "The Captivated Curator",
        "A Diligent Discoverer",
        "The Open-Minded Observer",
        "A Insightful Inquirer",
        "The Focused Forager",
        "A Bright Bibliophile",
        "The Wandering Wordsmith",
        "A Engaged Explorer",
        "The Investigative Imbiber",
        "A Mindful Maven"
    ];
    const randName = names[Math.floor(Math.random() * names.length)];

    async function _loginAsGuest() {
        const u = await loginAsGuest({
            name: randName
        })
        // forcefully update follow count
        if ($userFollows.size === 0) {
            ["fa984bd7dbb282f07e16e7ae87b26a2a7b9b90b7246a44771f0cf5ae58018f52", "a9434ee165ed01b286becfc2771ef1705d3537d051b387288898cc00d5c885be", "6e468422dfb74a5738702a8823b9b28168abab8655faacb6853cd0ee15deee93", "b17c59874dc05d7f6ec975bce04770c8b7fa9d37f3ad0096fdb76c9385d68928", "dace63b00c42e6e017d00dd190a9328386002ff597b841eb5ef91de4f1ce8491"].forEach(p => $userFollows.add(p));
        }
        $user = u;
    }
</script>

<AttentionButton on:click={_loginAsGuest}>
    <div class="flex items-center gap-2">
        <KeyIcon />
        <span >Continue as Guest</span>
    </div>
</AttentionButton>
