LOCKFILE := "pnpm-lock.yaml"

build:
    turbo build --filter=!highlighter-mobile
    
build-all:
    turbo build
    
build-lib:
    turbo build --filter=@highlighter/svelte-kit-lib

build-kind0:
    turbo run build --filter=@kind0/*

copy-mobile:
    ./mobile_cp.sh

clean:
    find . -name 'node_modules' -type d -prune -print -exec rm -rf '{}' \; \
    && pnpm install

renew:
    if [ -f {{LOCKFILE}} ]; then \
        rm {{LOCKFILE}}; \
    fi \
    && find . -name 'node_modules' -type d -prune -print -exec rm -rf '{}' \; \
    && pnpm install

renew-all:
    if [ -f {{LOCKFILE}} ]; then \
        rm {{LOCKFILE}}; \
    fi \
    && find . -name 'node_modules' -type d -prune -print -exec rm -rf '{}' \; \
    && pnpm store prune \
    && pnpm install

compile-ndk:
    ./ndk_compile.sh

branches:
    @echo "Current branch: `git branch --show-current`" \
        && if [[ -n $(git status --porcelain) ]]; then \
            git status --porcelain; \
        fi
    @echo "@packages branch: `cd packages && git branch --show-current`" \
        && cd packages && if [[ -n $(git status --porcelain) ]]; then \
            git status --porcelain; \
        fi
    @echo "packages/ndk branch: `cd packages/ndk && git branch --show-current`" \
        && cd packages/ndk && if [[ -n $(git status --porcelain) ]]; then \
            git status --porcelain; \
        fi

update:
    git submodule update --recursive --remote
    cd packages && git checkout master && git pull

initialize:
    cd packages && git checkout master & cd ..
    pnpm install
    ./ndk_compile.sh
    just build
    echo "[highlighter] Initialized."

update_ndk_pin:
    git submodule update --recursive --remote
    cd packages && git checkout master && git pull && cd ..
    cd packages/ndk && git checkout b197635 & cd ../..
    pnpm install
    ./ndk_compile.sh