#!/bin/bash

BASE_NAME=$(basename "$0")

TAURI_ANDROID_BUNDLE="./src-tauri/gen/android"
#TAURI_ANDROID_TARGET="./target/android-"

main() {
    echo "[$BASE_NAME] Start."

    if [ -d $TAURI_ANDROID_BUNDLE ]; then \
        sudo rm -r $TAURI_ANDROID_BUNDLE; \
    fi

    #if [ -d $TAURI_ANDROID_TARGET ]; then \
    #    sudo rm -r $TAURI_ANDROID_TARGET; \
    #fi

    just android-init
    echo "[$BASE_NAME] Done."
}

main