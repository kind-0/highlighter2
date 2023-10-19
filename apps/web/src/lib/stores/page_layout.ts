import { writable } from "svelte/store";

export type PageLayoutOptions = undefined | `mobile_addtopspace`

export const page_layout = writable<PageLayoutOptions>(undefined);