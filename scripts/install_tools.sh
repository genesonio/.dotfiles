#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

PACMAN_PKGS=(
  # Hyprland desktop
  hyprland hypridle hyprlock hyprpaper hyprpicker
  xdg-desktop-portal-hyprland xdg-desktop-portal-gtk qt5-wayland qt6-wayland
  waybar rofi rofi-calc kitty thunar flameshot dunst libnotify
  wl-clipboard jq brightnessctl playerctl

  # Audio
  pipewire pipewire-pulse pipewire-alsa wireplumber libpulse pavucontrol sound-theme-freedesktop

  # Fonts and cursor
  ttf-firacode-nerd noto-fonts noto-fonts-emoji inter-font adwaita-cursors

  # Shell and editor
  zsh starship tmux fzf ripgrep neovim git stow base-devel unzip curl wget python

  # Web dev
  nvm nodejs npm pnpm yarn bun typescript go
  docker docker-compose docker-buildx

  # Tools used by .zshrc functions
  openssh speedtest-cli scrcpy android-tools v4l2loopback-dkms linux-headers ntfs-3g

  flatpak
)

MANUAL=(
  "ngrok   - not in pacman/Flathub: https://ngrok.com/download"
  "doppler - not in pacman/Flathub: https://docs.doppler.com/docs/install-cli"
  "hyprcap - not in pacman/Flathub (SUPER+SHIFT+R): https://github.com/alonso-herreros/hyprcap"
  "~/wallpapers/default.png - used by hyprpaper and hyprlock"
)

[ -f /etc/arch-release ] || { echo "This script is for Arch Linux."; exit 1; }

echo "==> Installing pacman packages"
sudo pacman -Syu --needed --noconfirm "${PACMAN_PKGS[@]}"

echo "==> Adding Flathub"
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "==> Linking dotfiles"
# A real ~/.local/bin stops stow from folding it into a symlink to the repo,
# which would make installers drop their binaries inside the dotfiles.
mkdir -p "$HOME/.local/bin"
stow -d "$DOTFILES" -t "$HOME" .

echo "==> Installing oh-my-zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSH_CUSTOM_PLUGINS="$HOME/.oh-my-zsh/custom/plugins"
[ -d "$ZSH_CUSTOM_PLUGINS/zsh-syntax-highlighting" ] || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM_PLUGINS/zsh-syntax-highlighting"
[ -d "$ZSH_CUSTOM_PLUGINS/zsh-autosuggestions" ] || git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM_PLUGINS/zsh-autosuggestions"

echo "==> Setting zsh as default shell"
[ "$SHELL" = "$(command -v zsh)" ] || chsh -s "$(command -v zsh)"

echo "==> Enabling docker"
sudo systemctl enable --now docker.service
sudo usermod -aG docker "$USER"

echo "==> Configuring v4l2loopback for cam (phone camera on /dev/video1)"
echo "v4l2loopback" | sudo tee /etc/modules-load.d/v4l2loopback.conf >/dev/null
echo 'options v4l2loopback video_nr=1 card_label="Phone Camera" exclusive_caps=1' | sudo tee /etc/modprobe.d/v4l2loopback.conf >/dev/null
sudo modprobe v4l2loopback

# nvim's undodir (sets.lua) is not created automatically
mkdir -p "$HOME/.vim/undodir"

echo
echo "Done. Log out and back in for the shell and docker group to apply."
echo "Install these yourself:"
printf '  - %s\n' "${MANUAL[@]}"
