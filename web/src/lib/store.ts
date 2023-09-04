import { writable } from 'svelte/store';

export type ScopeSelection = {
    label: string;
    id: string;
    pubkeys: string[] | undefined;
};
export const currentScope = writable<ScopeSelection>({
    label: 'global',
    id: 'global',
    pubkeys: undefined,
});

let zapEvent: any;

export const zap = writable(zapEvent);

export const pageTitle = writable<string | null>(null);
export const pageSubtitle = writable<string | null>(null);