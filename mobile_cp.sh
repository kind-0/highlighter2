#!/bin/bash

copy_web_source_code() {
    app_web_src="$1/src"
    app_web_static="$1/static"

    app_mobile_src="$2/src"
    app_mobile_static="$2/static"

    if [ -d "$app_web_src" ]; then
        if [ ! -d "$app_mobile_src" ]; then
            mkdir -p "$app_mobile_src"
        fi
        if [ -d "$app_mobile_src" ]; then
            rm -rf "$app_mobile_src"
            mkdir "$app_mobile_src"
        fi
        cp -r "$app_web_src"/* "$app_mobile_src"
        echo "Files copied successfully from $app_web_src to $app_mobile_src"
    else
        echo "Source directory $app_web_src does not exist."
    fi

    if [ -d "$app_web_static" ]; then
        if [ ! -d "$app_mobile_static" ]; then
            mkdir -p "$app_mobile_static"
        fi
        cp -r "$app_web_static"/* "$app_mobile_static"
        echo "Files copied successfully from $app_web_static to $app_mobile_static"
    else
        echo "Static directory $app_web_static does not exist."
    fi
}

startsWith() {
  local string="$1"
  local prefix="$2"
  [[ "$string" == "$prefix"* ]]
}

search_and_replace() {
  local file_path="$1"
  local matchStr="$2"
  local replaceStr="$3"
  local appendLastLine="$4"

  local temp_file="$(mktemp)"

  if [ -e "$file_path" ]; then
    while IFS= read -r line; do
        line="${line#"${line%%[![:space:]]*}"}"
        line="${line%"${line##*[![:space:]]}"}"

        if startsWith "$line" "$matchStr"; then
            echo "$replaceStr" >> "$temp_file"
        else
            echo "$line" >> "$temp_file"
        fi
    done < "$file_path"
    if [ -n "$appendLastLine" ]; then
      echo "$appendLastLine" >> "$temp_file"
    fi

    mv "$temp_file" "$file_path"
  else
    echo "File not found: $file_path"
  fi
}

write_tmp_json_key() {
  local file_path="$1"
  local output_file="$2"
  local json_key="$3"

  if [ -e "$file_path" ]; then
    jq "$json_key" "$file_path" > "$output_file"

  else
    echo "File not found: $file_path"
  fi
}

update_dev_dependencies() {
  read_json_file="$1"
  output_json_file="$2"

  if [ ! -f "$read_json_file" ]; then
    echo "Error: Input JSON file $read_json_file does not exist."
    return 1
  fi

  if [ ! -f "$output_json_file" ]; then
    echo "Error: Output JSON file $output_json_file does not exist."
    return 1
  fi

  json_object=$(cat "$read_json_file")
  tmp_json="tmp_package.json"
  jq --argjson obj "$json_object" '.devDependencies = $obj' "$output_json_file" > "$tmp_json"

  if [ $? -ne 0 ]; then
    echo "Error: jq failed to update $output_json_file."
    return 1
  fi

  mv "$tmp_json" "$output_json_file"
  echo "Package.json devDependencies copied successfully to $output_json_file"
}

update_dependencies() {
  read_json_file="$1"
  output_json_file="$2"

  if [ ! -f "$read_json_file" ]; then
    echo "Error: Input JSON file $read_json_file does not exist."
    return 1
  fi

  if [ ! -f "$output_json_file" ]; then
    echo "Error: Output JSON file $output_json_file does not exist."
    return 1
  fi

  json_object=$(cat "$read_json_file")
  tmp_json="tmp_package.json"
  jq --argjson obj "$json_object" '.dependencies = $obj' "$output_json_file" > "$tmp_json"

  append_dependencies=(
      "@tauri-apps/plugin-dialog https://github.com/tauri-apps/tauri-plugin-dialog#v2"
  )

  for key in "${!append_dependencies[@]}"; do
    append_dependencies_item="${append_dependencies[$key]}"
    IFS=" " read -ra parts <<< "$append_dependencies_item"
    if [ "${#parts[@]}" -eq 2 ]; then
        append_key="${parts[0]}"
        append_value="${parts[1]}"
        jq --arg k "$append_key" --arg v "$append_value" '.dependencies[$k] = $v' "$tmp_json" > "$tmp_json.tmp" && mv "$tmp_json.tmp" "$tmp_json"
    else
        echo "Invalid input format. Expected 'new_key:new_value'."
    fi
done
  if [ $? -ne 0 ]; then
    echo "Error: jq failed to update $output_json_file."
    return 1
  fi

  mv "$tmp_json" "$output_json_file"
  echo "Package.json dependencies copied successfully to $output_json_file"
}

tmp_json_file="./tmp.json"

dir_web="./apps/web"
dir_mobile="./mobile"

# copy source code from web into mobile
copy_web_source_code "$dir_web" "$dir_mobile"

# update mobile package.json devDependencies
write_tmp_json_key "$dir_web/package.json" "$tmp_json_file" '.devDependencies'
update_dev_dependencies "$tmp_json_file" "$dir_mobile/package.json"

# update mobile package.json dependencies
write_tmp_json_key "$dir_web/package.json" "$tmp_json_file" '.dependencies'
update_dependencies "$tmp_json_file" "$dir_mobile/package.json" 
rm "tmp.json"

# modify mobile files
modify_text_1_path="$dir_mobile/src/routes/+layout.svelte"
modify_text_1_match="import { pwaInfo }"
modify_text_1_replace="// import { pwaInfo } from 'virtual:pwa-info';"
search_and_replace "$modify_text_1_path" "$modify_text_1_match" "$modify_text_1_replace" "</style>"

modify_text_2_path="$dir_mobile/src/routes/+layout.svelte"
modify_text_2_match="$: webManifestLink = pwaInfo"
modify_text_2_replace="$: webManifestLink = ''"
search_and_replace "$modify_text_2_path" "$modify_text_2_match" "$modify_text_2_replace"