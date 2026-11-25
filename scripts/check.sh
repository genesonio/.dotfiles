#!/usr/bin/env bash
set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit

status=0
run() {
  echo "==> $*"
  "$@" || status=1
}

run shellcheck scripts/*.sh .scripts/* .githooks/*
run zsh -n .zshrc
run Hyprland --verify-config -c .config/hypr/hyprland.lua

exit "$status"
