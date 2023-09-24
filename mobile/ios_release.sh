#!/bin/bash


BASE_NAME=$(basename "$0")

APP_NAME="Highlighter"
PROJECT_DIR="."

APP_APPLE_ID="1234567890"
APP_BUNDLE_VERSION="20011231.120101"
APP_VERSION="0.0.1"
APP_BUNDLE_ID="com.highlighter.ios"

USER="$HIGHLIGHTER_APPLE_USER"
PASSWORD="test"
#PASSWORD="$(file_encrypted_read.sh highlighter_apple_password)"

APPLE_DISTRIBUTION_CERT="Apple Distribution: Tyson Lupul"
THIRD_PARTY_MAC_DEVELOPER_CERT="3rd Party Mac Developer Installer: Tyson Lupul ($HIGHLIGHTER_TAURI_APPLE_DEVELOPMENT_TEAM)"

APP_BUNDLE="$APP_NAME.app"
APP_EXECUTABLE="$APP_BUNDLE/Contents/MacOS/$APP_NAME"
APP_PACKAGE="$APP_NAME.pkg"

APP_RELEASE_DIR="$PROJECT_DIR/release/ios"
APP_RELEASE_ENTITLEMENTS="$PROJECT_DIR/entitlements.plist"
APP_RELEASE_PROVISION_PROFILE="$HIGHLIGHTER_IOS_PROVISION_PROFILE_FILE"

validate_fields() {
	if [ -z "$USER" ]; then
		echo "Error: USER is empty or undefined."
		exit 1
	fi

	if [ -z "$PASSWORD" ]; then
		echo "Error: PASSWORD is empty or undefined."
		exit 1
	fi

	if [ ! -f "$APP_RELEASE_ENTITLEMENTS" ]; then
		echo "The app release entitlements file does not exist: $APP_RELEASE_ENTITLEMENTS"
		exit 1
	fi

	if [ ! -f "$APP_RELEASE_PROVISION_PROFILE" ]; then
		echo "The app provision profile file does not exist: $APP_RELEASE_PROVISION_PROFILE"
		exit 1
	fi
}

run_app_build() {
	npm run tauri build -- --target universal-apple-darwin
	echo "[$BASE_NAME] tauri build complete"

	cp -r "$PROJECT_DIR/target/universal-apple-darwin/release/bundle/macos/$APP_BUNDLE" "$APP_RELEASE_DIR"
	echo "[$BASE_NAME] app bundle copy complete"

	cp -r "$APP_RELEASE_PROVISION_PROFILE" "$APP_RELEASE_DIR/$APP_BUNDLE/Contents/embedded.provisionprofile"
	echo "[$BASE_NAME] provision profile copy complete"
}

run_app_codesign() {
	codesign \
		--sign "$APPLE_DISTRIBUTION_CERT" \
		--entitlements "$APP_RELEASE_ENTITLEMENTS" \
		"$APP_RELEASE_DIR/$APP_EXECUTABLE"
	echo "[$BASE_NAME] codesign complete"
}

run_app_release() {
	productbuild \
		--sign "$THIRD_PARTY_MAC_DEVELOPER_CERT" \
		--component "$APP_BUNDLE" "/Applications" \
		"$APP_PACKAGE"
	echo "[$BASE_NAME] productbuild complete"

	xcrun altool \
		--upload-package "$APP_PACKAGE" \
		--type macos \
		--apple-id "$APP_APPLE_ID" \
		--bundle-version "$APP_BUNDLE_VERSION" \
		--bundle-short-version-string "$APP_VERSION" \
		--bundle-id "$APP_BUNDLE_ID" \
		-u "$USER" \
		-p "$PASSWORD"
	echo "[$BASE_NAME] upload complete"
}

main() {
	echo "[$BASE_NAME] Start."
	validate_fields
	run_app_build
	run_app_codesign
	echo "[$BASE_NAME] Done."
}

main