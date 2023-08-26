LOCKFILE := "package-lock.json"

build:
    npm run build
change:
    npm run changeset
renew:
    if [ -d {{LOCKFILE}} ]; then \
        rm {{LOCKFILE}}; \
    fi \
    && find . -name 'node_modules' -type d -prune -print -exec rm -rf '{}' \; \
    && npm i