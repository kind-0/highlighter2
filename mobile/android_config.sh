#!/bin/bash

BASE_NAME=$(basename "$0")

PROJECT_DIR="."

APP_RELEASE_GRADLE_BUILD_PATH="$PROJECT_DIR/src-tauri/gen/android/app/build.gradle.kts"
APP_RELEASE_GRADLE_BUILD_PATH_TMP="$APP_RELEASE_GRADLE_BUILD_PATH.tmp"

modify_app_gradle_build() {
	local gradle_imports="$(cat <<EOF
import java.util.Properties
import java.io.FileInputStream
EOF
)"

	local gradle_keystore_info="$(cat <<EOF
val keyPropertiesFile = rootProject.file("key.properties")
val keyProperties = Properties()
keyProperties.load(FileInputStream(keyPropertiesFile))
EOF
)"

	local gradle_signingConfig="$(cat <<EOF
	signingConfigs {
   		create("release") {
       		keyAlias = keyProperties["keyAlias"] as String
       		keyPassword = keyProperties["keyPassword"] as String
       		storeFile = file(keyProperties["storeFile"] as String)
       		storePassword = keyProperties["storePassword"] as String
   		}
	}
EOF
)"

	local gradle_buildTypes_signingConfig="			signingConfig = signingConfigs.getByName(\"release\")"

	echo -n "" > $APP_RELEASE_GRADLE_BUILD_PATH_TMP

	while IFS= read -r line; do
		if [[ $line == "plugins {"* ]]; then
			echo -e "$gradle_imports\n" >> $APP_RELEASE_GRADLE_BUILD_PATH_TMP
			echo "$line" >> $APP_RELEASE_GRADLE_BUILD_PATH_TMP
		elif [[ $line == "android {"* ]]; then
			echo -e "$gradle_keystore_info\n" >> $APP_RELEASE_GRADLE_BUILD_PATH_TMP
			echo "$line" >> $APP_RELEASE_GRADLE_BUILD_PATH_TMP
		elif [[ $line == "    buildTypes {"* ]]; then
			echo -e "$gradle_signingConfig" >> $APP_RELEASE_GRADLE_BUILD_PATH_TMP
			echo "$line" >> $APP_RELEASE_GRADLE_BUILD_PATH_TMP
		elif [[ $line == "            isMinifyEnabled = true"* ]]; then
			echo -e "$gradle_buildTypes_signingConfig" >> $APP_RELEASE_GRADLE_BUILD_PATH_TMP
			echo "$line" >> $APP_RELEASE_GRADLE_BUILD_PATH_TMP
		else
			echo "$line" >> $APP_RELEASE_GRADLE_BUILD_PATH_TMP
		fi
	done < "$APP_RELEASE_GRADLE_BUILD_PATH"

	mv $APP_RELEASE_GRADLE_BUILD_PATH_TMP $APP_RELEASE_GRADLE_BUILD_PATH
}


main() {
    echo "[$BASE_NAME] Start."
    modify_app_gradle_build
    echo "[$BASE_NAME] Done."
}

main