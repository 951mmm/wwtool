#! /usr/bin/env bash
set -euo pipefail

## func
function check_cmd() {
  local cmd=$1
  echo check if "$cmd" exists...
  if [ -z $(which "$cmd") ]; then
    echo "$cmd not found. install it and rerun the script!"
    exit 1
  fi
  echo "$cmd" exists!
}

function check_cmd_gracefully() {
  local cmd=$1
  if [ -z $(which "$cmd") ]; then
    echo "$cmd not found!"
    echo try install "$cmd"...
    return 1
  fi
  return 0
}

## basic
function check_nvim() {
  check_cmd nvim
}

function check_sync() {
  echo check if nvim config exist...
  if [ ! -d $HOME/Public/sync/cfg/nvim ]; then
    echo nvim config not found, try get sync
    get_sync
  fi
}

function get_sync() {
  echo get nvim config...
  local resposity_url=git@github.com:951mmm/bash-cfg.git
  mkdir -p $HOME/Public/sync
  cd $HOME/Public/sync/
  git clone "$resposity_url" cfg
  cp -r cfg/nvim $HOME/.config/
}

## pyright
function check_fnm() {
  check_cmd fnm
}

## rust
function check_rust() {
  check_cmd cargo
}

function check_bascon() {
  macon_bin_path=$HOME/.local/share/nvim/mason/bin
  if [ ! -s "$macon_bin_path/bacon" ] || [ ! -s "$macon_bin_path/bacon-ls" ]; then
    echo run :MasonInstall bacon bacon-ls on nvim
    exit 1
  fi
}

function bacon_init() {
  mason_bin_path=$HOME/.local/share/nvim/mason/bin
  toml=$($mason_bin_path/bacon --prefs)
  if [ ! -s "$toml" ]; then
    echo bad toml path: "$toml"
    return 1
  fi
  if [ ! -z $(grep bacon-ls "$toml") ]; then
    echo already init "$toml" for bacon-ls
    return 0
  fi
  cat <<EOF >>"$toml"
[jobs.bacon-ls]
command = [
  "cargo", "clippy",
  "--workspace", "--all-targets", "--all-features",
  "--message-format", "json-diagnostic-rendered-ansi",
]
analyzer = "cargo_json"
need_stdout = true

[exports.cargo-json-spans]
auto = true
exporter = "analyzer"
line_format = """\
  {diagnostic.level}|:|{span.file_name}|:|{span.line_start}|:|{span.line_end}|:|\
  {span.column_start}|:|{span.column_end}|:|{diagnostic.message}|:|{diagnostic.rendered}|:|\
  {span.suggested_replacement}\
"""
path = ".bacon-locations"
EOF
}
function check_rg() {
  check_cmd_gracefully rg ||
    brew install ripgrep
}
function check_fd() {
  check_cmd_gracefully fd ||
    brew install fd
}
function main() {
  check_nvim
  check_sync
  check_fnm
  check_rust
  check_bascon
  bacon_init
  check_rg
  check_fd
}

main
