# dotfiles

Arch Linux + Hyprland (uwsm session), zsh, tmux, Neovim, kitty. Files are linked into `$HOME` with GNU stow.

## Fresh install

```sh
git clone git@github.com:genesonio/.dotfiles.git ~/.dotfiles
~/.dotfiles/scripts/install_tools.sh
```

The script installs everything from pacman, adds Flathub, stows the dotfiles, copies `etc/` into `/etc`,
enables the user services and prints what has to be installed by hand (ngrok, doppler, hyprcap).
Log out and back in when it finishes.

## Layout

| Path | What |
|---|---|
| `.config/hypr/` | Hyprland (`hyprland.lua`), hypridle, hyprlock, hyprpaper |
| `.config/waybar/`, `.config/rofi/`, `.config/vicinae/`, `.config/kitty/` | Bar, launchers, terminal |
| `.config/nvim/` | Neovim (lazy.nvim, `lazy-lock.json` pins plugins) |
| `.zshrc`, `.tmux.conf`, `.scripts/` | Shell, tmux and the tmux session pickers |
| `etc/` | System files copied to `/etc` (SDDM autologin, v4l2loopback) — not stowed |
| `scripts/` | `install_tools.sh`, `check.sh` — not stowed |

Session daemons (waybar, hyprpaper, hypridle, polkit agent) are systemd user services started by
`graphical-session.target`; restart one with `systemctl --user restart <name>`.

## Not in the repo

- `~/.zshrc.local` — private or machine-specific shell functions (sourced by `.zshrc`)
- `~/.ssh/config` — SSH hosts and which key each one uses
- `~/.gitconfig`

## Checks

`scripts/check.sh` runs shellcheck, `zsh -n` and `Hyprland --verify-config`. It runs as a pre-commit hook
(`core.hooksPath = .githooks`, set by the install script).
