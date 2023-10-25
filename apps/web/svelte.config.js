import adapter from "@sveltejs/adapter-node";
import { vitePreprocess } from "@sveltejs/kit/vite";

/** @type {import('@sveltejs/kit').Config} */
const config = {
    kit: {
        adapter: adapter({ out: "build" }),
        alias: {
            $actions: "src/lib/actions",
            $components: "src/lib/components",
            $modals: "src/lib/modals",
            $icons: "src/lib/icons",
            $stores: "src/lib/stores",
            $utils: "src/lib/utils",
        },
    },
    preprocess: vitePreprocess(),
    vitePlugin: {
        inspector: {
            holdMode: true,
            toggleKeyCombo: "control-shift",
        },
    },
    onwarn: (warning, handler) => {
        if (warning.code.startsWith("a11y-")) {
            return;
        }
        handler(warning);
    },
};

export default config;
