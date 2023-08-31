LOCKFILE := "pnpm-lock.yaml"

build:
    turbo build

renew:
    if [ -d {{LOCKFILE}} ]; then \
        rm {{LOCKFILE}}; \
    fi \
    && find . -name 'node_modules' -type d -prune -print -exec rm -rf '{}' \; \
    && pnpm install

renew-all:
    if [ -d {{LOCKFILE}} ]; then \
        rm {{LOCKFILE}}; \
    fi \
    && find . -name 'node_modules' -type d -prune -print -exec rm -rf '{}' \; \
    && pnpm store prune \
    && pnpm install

compile-ndk:
    ./ndk_compile.sh