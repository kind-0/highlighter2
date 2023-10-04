import { afterUpdate, tick } from 'svelte';

export function useEffect(fn: () => void, get_deps: () => any): void {
	let previous: never[] = [];

	afterUpdate(async () => {
		const deps = get_deps();
		if (deps.some((dep: any, i: number) => dep !== previous[i])) {
			await tick();
			fn();
			previous = deps;
		}
	});
}
