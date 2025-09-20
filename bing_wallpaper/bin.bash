#! /bin/bash
set -euo pipefail
wall_paper_path="$HOME/Pictures/bing_wp"
## zh wp
wp_info_url=https://bing.wdbyte.com/zh-cn/today
device_uuid=536de735-0566-4c59-8b37-cb168cedada5

function init() {
  if [ ! -d "$wall_paper_path" ]; then
    mkdir -p "$wall_paper_path"
  fi
}

function get_wp_info() {
  curl \
    -H "client-version: 0.1.0" \
    -H "client-device-uuid: $device_uuid" \
    "$wp_info_url"
}

function build_uri() {
  local path="$1"
  echo "file://$path"
}

function get_cur_wp_uri() {
  echo $(gsettings get org.gnome.desktop.background picture-uri)
}

function set_cur_wp() {
  local uri="$1"
  gsettings set org.gnome.desktop.background picture-uri "$uri"
}
init
wp_info=$(get_wp_info)
file_name=$(echo "$wp_info" | jq -r .file_name)
url=$(echo "$wp_info" | jq -r .url)
local_path="$wall_paper_path/$file_name"
if [ ! -s "$local_path" ]; then
  wget "$url" -O "$local_path"
fi

file_uri=$(build_uri "$local_path")
cur_wp_uri=$(get_cur_wp_uri)
if [ "$cur_wp_uri" = "$file_uri" ]; then
  exit 0
fi
set_cur_wp $file_uri
