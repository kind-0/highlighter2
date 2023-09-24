#!/bin/bash

BASE_NAME=$(basename "$0")

APP_NAME="Highlighter"
PROJECT_DIR="."

run_app_build() {
	just android-build
	echo "[$BASE_NAME] tauri build complete"
}

main() {
	echo "[$BASE_NAME] Start."
	#validate_fields
	run_app_build
	#run_app_codesign
	echo "[$BASE_NAME] Done."
}

main
