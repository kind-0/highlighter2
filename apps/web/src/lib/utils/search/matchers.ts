import { goto } from "$app/navigation";
import { nip19 } from "nostr-tools";
import { ndk } from "@kind0/ui-common";
import { get as getStore } from "svelte/store";
import type { MediaType } from ".";
import { NDKKind } from "@nostr-dev-kit/ndk";

function findBech32Match(data: string): string | undefined {
    const midUrlEventMatcher = /(naddr|nevent|note)1([a-zA-Z0-9]+)\/?$/i;

    if (data.match(midUrlEventMatcher)) {
        return data.match(midUrlEventMatcher)![0];
    }
}

export function tryToLoadRss(data: string): MediaType | undefined {
    // if the data is a URL, check if it's an RSS feed
    try {
        const url = new URL(data);

        // if url ends with rss or atom, it's probably a feed
        if (url.pathname.match(/(rss|atom)$/i)) {
            goto(`/reader/rss/${encodeURIComponent(data)}`);
            return "rss";
        }
    } catch (e) { /* empty */ }
}

export function tryToLoadUserBech32(data: string): MediaType | undefined {
    try {
        const midUrlEventMatcher = /(npub|nprofile)1([a-zA-Z0-9]+)\/?$/i;

        if (data.match(midUrlEventMatcher)) {
            const match = data.match(midUrlEventMatcher)![0];

            goto(`/p/${encodeURIComponent(match)}`);
            return "bech32";
        }
    } catch (e) { /* empty */ }
}

export async function tryToLoadBech32(data: string): Promise<MediaType | undefined> {
    try {
        const bech32Match = findBech32Match(data!);

        if (!bech32Match) return;

        const $ndk = getStore(ndk);
        const event = await $ndk.fetchEvent(bech32Match);

        if (!event) return;

        if (event.kind! >= 65002 && event.kind! <= 65999) {
            goto(`/dvm/${encodeURIComponent(bech32Match)}`);
            return "bech32";
        } else if (event.kind === NDKKind.Highlight) {
            goto(`/e/${encodeURIComponent(bech32Match)}`);
            return "bech32";
        }

        goto(`/a/${encodeURIComponent(bech32Match)}`);
        return "bech32";
    } catch (e) { /* empty */ }
}

export function tryToLoadTopic(data: string): MediaType | undefined {
    if (data!.startsWith('#')) {
        const topic = data!.replace(/^#/, '');
        goto(`/topic/${encodeURIComponent(topic)}`);
        return 'topic';
    }
}

export function tryToLoadSearch(data: string): MediaType | undefined {
    try {
        new URL(data);
        return undefined;
    } catch (e) {}

    goto(`/search?q=${encodeURIComponent(data)}`);
    return 'search';
}

export function tryToLoadDVM(data: string): MediaType | undefined {
    return (
        tryToLoadVideo(data) ||
        tryToLoadAudio(data) ||
        tryToLoadOvercast(data) ||
        tryToLoadYoutube(data)
    );
}

function tryToLoadVideo(data: string): string | undefined {
    if (data!.match(/\.(mov|mp4)+$/i)) {
        return 'video';
    }
}

function tryToLoadAudio(data: string): string | undefined {
    if (data!.match(/\.(mp3|wav)+$/i)) {
        return 'audio';
    }
}

function tryToLoadOvercast(data: string): string | undefined {
    if (data!.startsWith('https://overcast.fm/')) {
        return 'overcast';
    }
}

function tryToLoadYoutube(data: string): string | undefined {
    if (data!.startsWith('https://www.youtube.com/')) {
        return 'youtube';
    }
}