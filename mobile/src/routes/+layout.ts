export const prerender = false
export const ssr = false

//import { ndk } from '$lib/store/ndk';

export async function load() {
    console.log(`[highlighter] Starting app.`)
    try {
        //const _ndk = get(ndk)
        //await _ndk.connect()
        console.log(`[highlighter] Connected to Nostr relay.`)
    } catch (e) {
        console.log(`[highlighter] Connection not established to Nostr relay.`)
    } finally {
        return {}
    }
}