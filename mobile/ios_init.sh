#!/bin/bash

BASE_NAME=$(basename "$0")

TAURI_IOS_BUNDLE="./src-tauri/gen/apple"
TAURI_IOS_TARGET="./target/aarch64-apple-ios"
TAURI_IOS_TARGET_SIM="./target/aarch64-apple-ios-sim"

export TAURI_APPLE_DEVELOPMENT_TEAM="$HIGHLIGHTER_TAURI_APPLE_DEVELOPMENT_TEAM"

main() {
    echo "[$BASE_NAME] Start."

    if [ -d $TAURI_IOS_BUNDLE ]; then \
        sudo rm -r $TAURI_IOS_BUNDLE; \
    fi

    if [ -d $TAURI_IOS_TARGET ]; then \
        sudo rm -r $TAURI_IOS_TARGET; \
    fi

    if [ -d $TAURI_IOS_TARGET_SIM ]; then \
        sudo rm -r $TAURI_IOS_TARGET_SIM; \
    fi

    just ios-init
    echo "[$BASE_NAME] Done."
}

main