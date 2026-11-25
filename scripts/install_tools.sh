#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

PACMAN_PKGS=(
  # Hyprland desktop
  hyprland hypridle hyprlock hyprpaper hyprpicker hyprpolkitagent uwsm sddm
  xdg-desktop-portal-hyprland xdg-desktop-portal-gtk qt5-wayland qt6-wayland
  waybar kitty thunar flameshot dunst libnotify
  wl-clipboard jq brightnessctl playerctl

  # Audio
  pipewire pipewire-pulse pipewire-alsa wireplumber libpulse pavucontrol sound-theme-freedesktop

  # Fonts and cursor
  ttf-firacode-nerd noto-fonts noto-fonts-emoji inter-font adwaita-cursors

  # Shell and editor
  zsh starship tmux fzf ripgrep neovim tree-sitter-cli imagemagick git stow base-devel unzip curl wget python shellcheck

  # Web dev
  fnm nodejs npm pnpm yarn bun typescript go
  docker docker-compose docker-buildx

  # Tools used by .zshrc functions
  zram-generator pacman-contrib openssh speedtest-cli scrcpy android-tools v4l2loopback-dkms linux-headers ntfs-3g

  flatpak
)

MANUAL=(
  "ngrok   - not in pacman/Flathub: https://ngrok.com/download"
  "doppler - not in pacman/Flathub: https://docs.doppler.com/docs/install-cli"
  "hyprcap - not in pacman/Flathub (SUPER+SHIFT+R): https://github.com/alonso-herreros/hyprcap"
  "vicinae - not in pacman/Flathub (SUPER+R, clipboard SUPER+SHIFT+V, emoji SUPER+.): read https://vicinae.com/install, run it with --prefix ~/.local, then systemctl --user enable --now vicinae.service"
  "$HOME/wallpapers/default.png - used by hyprpaper and hyprlock"
  "Private shell functions go in ~/.zshrc.local; SSH hosts in ~/.ssh/config"
)

[ -f /etc/arch-release ] || { echo "This script is for Arch Linux."; exit 1; }

echo "==> Installing pacman packages"
sudo pacman -Syu --needed --noconfirm "${PACMAN_PKGS[@]}"

echo "==> Adding Flathub"
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "==> Linking dotfiles"
# A real ~/.local/bin stops stow from folding it into a symlink to the repo,
# which would make installers drop their binaries inside the dotfiles.
mkdir -p "$HOME/.local/bin" "$HOME/.config/systemd/user" "$HOME/.config/vicinae" "$HOME/.config/uwsm"
stow -d "$DOTFILES" -t "$HOME" .

echo "==> Enabling session services (started by the uwsm session)"
systemctl --user enable waybar.service hyprpaper.service hypridle.service hyprpolkitagent.service ssh-agent.socket

git -C "$DOTFILES" config core.hooksPath .githooks

echo "==> Seeding vicinae settings and web search shortcuts (vicinae rewrites both, so they are copied, not stowed)"
[ -f "$HOME/.config/vicinae/settings.json" ] || printf '{\n  "imports": ["./dotfiles.jsonc"]\n}\n' > "$HOME/.config/vicinae/settings.json"
mkdir -p "$HOME/.local/share/vicinae/shortcuts"
cp -n "$DOTFILES/scripts/vicinae-shortcuts.json" "$HOME/.local/share/vicinae/shortcuts/shortcuts.json"

echo "==> Dark mode for GTK, Electron, Flatpak apps and websites (via xdg-desktop-portal)"
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark

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

echo "==> Installing system config files (SDDM autologin, v4l2loopback for cam, zram, journald cap)"
sudo cp -r --no-preserve=ownership "$DOTFILES/etc/." /etc/
sudo sed -i "s/^User=.*/User=$USER/" /etc/sddm.conf.d/autologin.conf
sudo systemctl enable sddm.service paccache.timer
sudo systemctl daemon-reload
sudo systemctl start systemd-zram-setup@zram0.service
sudo sed -i 's/^#Color$/Color/' /etc/pacman.conf
sudo modprobe v4l2loopback

echo "==> Installing Node LTS with fnm"
eval "$(fnm env --shell bash)"
fnm install --lts
fnm default "$(fnm list | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -1)"

# nvim's undodir (sets.lua) is not created automatically
mkdir -p "$HOME/.vim/undodir"

echo
echo "Done. Log out and back in for the shell and docker group to apply."
echo "Install these yourself:"
printf '  - %s\n' "${MANUAL[@]}"
