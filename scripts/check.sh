#!/usr/bin/env bash
set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit

status=0

check() {
  local name=$1 out
  shift
  if out=$("$@" 2>&1); then
    printf '\e[32m✓\e[0m %s\n' "$name"
  else
    printf '\e[31m✗\e[0m %s\n' "$name"
    printf '%s\n' "$out" | sed '/./,$!d; s/^/    /'
    status=1
  fi
}

# Hyprland prints debug logs before the result; keep only the errors
# shellcheck disable=SC2329 # called through check()
hypr_verify() {
  local out
  out=$(Hyprland --verify-config -c .config/hypr/hyprland.lua 2>&1) && return 0
  printf '%s\n' "$out" | sed -n '/Config parsing result/,$p' | tail -n +2 | sed '/^$/d'
  return 1
}

check "shellcheck" shellcheck scripts/*.sh .scripts/* .githooks/* .config/waybar/scripts/*.sh
check "zsh syntax" zsh -n .zshrc
check "hyprland.lua" hypr_verify

exit "$status"
