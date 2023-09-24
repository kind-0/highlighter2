#!/bin/bash

BASE_NAME=$(basename "$0")

PROJECT_DIR="."

APP_RELEASE_KEYSTORE_PASSWORD="$(file_encrypted_read.sh highlighter_android_keystore_password)"
APP_RELEASE_KEYSTORE_PATH="$HIGHLIGHTER_ANDROID_KEYSTORE_UPLOAD_PATH"
APP_RELEASE_KEY_PROPERTIES_PATH="$PROJECT_DIR/src-tauri/gen/android/key.properties"

validate_fields() {
	if [ -z "$APP_RELEASE_KEYSTORE_PASSWORD" ]; then
		echo "Error: APP_RELEASE_KEYSTORE_PASSWORD is empty or undefined."
		exit 1
	fi

	if [ ! -f "$APP_RELEASE_KEYSTORE_PATH" ]; then
		echo "Error: APP_RELEASE_KEYSTORE_PATH is empty or undefined."
		exit 1
	fi
}

write_app_key_properties() {
	cat <<EOF > "$APP_RELEASE_KEY_PROPERTIES_PATH"
storePassword=$APP_RELEASE_KEYSTORE_PASSWORD
keyPassword=$APP_RELEASE_KEYSTORE_PASSWORD
keyAlias=upload
storeFile=$APP_RELEASE_KEYSTORE_PATH
EOF
}

run_app_build() {
	just android-build
	echo "[$BASE_NAME] tauri build complete"
}

main() {
	echo "[$BASE_NAME] Start."
	validate_fields
	write_app_key_properties
	run_app_build
	echo "[$BASE_NAME] Done."
}

main
