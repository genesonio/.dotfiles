# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# export PATH=$PATH:/usr/local/go/bin
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/.scripts:$PATH"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME=""

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time
zstyle ':omz:update' mode auto      # update automatically without asking

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

plugins=(git zsh-autosuggestions fzf aliases zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# if [ -z "$TMUX" ]
# then
#     tmux attach -t TMUX || tmux new -s TMUX
# fi

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias shconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias vim=nvim

alias ls="ls -la -h"

alias tm=tmux

alias tmk="tmux kill-session"

# alias air="/home/genesio/go/bin/air"

# alias templ="/home/genesio/go/bin/templ"

alias wbr="systemctl --user restart waybar"

bye() {
  echo "Updating system..."
  if ! { sudo pacman --noconfirm -Syu && flatpak update -y; }; then
    echo "❌ Update failed — aborting shutdown."
    return 1
  fi

  echo "Bye bye!"
  sleep 2

  echo "Shutting down..."
  shutdown -h now
}

so() {
  source ~/.zshrc
  if [ -f ~/.profile ]; then
    source ~/.profile
  fi
}

ssc() {
  nvim ~/.config/starship.toml
}

vimc() {
  cd ~/.config/nvim/
  nvim .
}

kic() {
  nvim ~/.config/kitty/kitty.conf
}

tmc() {
  nvim ~/.tmux.conf
}

zsc() {
  nvim ~/.zshrc
}

hyprc() {
  nvim ~/.config/hypr/hyprland.lua
}

wbrc() {
  nvim ~/.config/waybar/config.jsonc
}

n() {
  nvim .
}

temp() {
  rm -rf ~/Downloads/TEMP && mkdir ~/Downloads/TEMP
}

pm() {
    if [ -f yarn.lock ]; then
        yarn "$@"
    elif [ -f pnpm-lock.yaml ]; then
        pnpm "$@"
    elif [ -f package-lock.json ]; then
        npm "$@"
    elif [ -f bun.lock ] || [ -f bun.lockb ]; then
        bun "$@"
    else
      echo "No package manager found"
    fi
}

dpm() {
    if [ -f yarn.lock ]; then
        doppler run -- yarn "$@"
    elif [ -f pnpm-lock.yaml ]; then
        doppler run -- pnpm "$@"
    elif [ -f package-lock.json ]; then
        doppler run -- npm "$@"
    elif [ -f bun.lock ] || [ -f bun.lockb ]; then
        doppler run -- bun "$@"
    else
      echo "No package manager found"
    fi
}

cdp() {
    selected=$(find ~/Github -mindepth 1 -maxdepth 1 -type d | fzf --preview 'ls {}' --query "$1" --select-1)
    [ -n "$selected" ] || return
    cd "$selected"
}

cdd() {
    selected=$(find ~/Dockers -mindepth 1 -maxdepth 1 -type d | fzf --preview 'ls {}' --query "$1" --select-1)
    [ -n "$selected" ] || return
    cd "$selected"
}

vp() {
    selected=$(find ~/Github -mindepth 1 -maxdepth 1 -type d | fzf --preview 'ls {}' --query "$1" --select-1)
    [ -n "$selected" ] || return
    cd "$selected"
    nvim .
}

dup() {
  docker-compose up --build "$@"
}

down() {
  docker-compose down "$@"
}

speed() {
  speedtest --bytes "$@"
}

ggraph() {
  git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all
}

jcurl() {
    curl "$@" | jq
}

dot() {
    cd ~/.dotfiles
    nvim .
}

git() {
  if [ "$1" = fetch ]; then
    shift
    set -- fetch --all "$@"
  fi
  command git "$@"
}

cam() {
  command -v adb >/dev/null 2>&1 || { echo "adb not found"; return 1; }
  [ -e /dev/video1 ] || { echo "/dev/video1 missing, run: sudo modprobe v4l2loopback"; return 1; }

  # Build list: serial + model
  local choice serial
  choice=$(adb devices -l | tail -n +2 | awk 'NF{print $1}' | while read -r s; do
    model=$(adb -s "$s" shell getprop ro.product.model 2>/dev/null)
    echo "$s  $model"
  done | fzf --height=100% --ansi --prompt="Select device: ") || return 1

  # Extract serial from the selection (first word)
  serial=${choice%% *}
  if [ -z "$serial" ]; then
    echo "No device selected."
    return 1
  fi

  scrcpy --serial "$serial" \
    --video-source=camera \
    --camera-facing=back \
    --camera-size=1920x1080 \
    --video-bit-rate=8M \
    --max-fps=60 \
    --v4l2-sink=/dev/video1 \
    --no-window \
    --no-audio \
    --no-playback
}

jogos() {
  sudo mount -t ntfs-3g UUID=4E24DDB424DD9F71 /mnt/jogos
}

# vicinae has no package; review the install script before it runs
vup() {
  local f
  f=$(mktemp) || return
  curl -fsSL https://vicinae.com/install -o "$f" && less "$f" &&
    read -q "?Run it? [y/N] " && echo && bash "$f" --prefix ~/.local
  rm -f "$f"
}

notify-end() {
  paplay /usr/share/sounds/freedesktop/stereo/complete.oga & notify-send "Done" "$1"
}

bindkey -v

bindkey -s ^f "tmux-sessionizer\n"
bindkey -s ^g "tmux-session-fzf\n"
# bindkey -s ^k "tmux kill-session\n"

eval "$(starship init zsh)"

eval "$(fnm env --use-on-cd --version-file-strategy=recursive --shell zsh)"

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# Turso
export PATH="$HOME/.turso:$PATH"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# opencode
export PATH="$HOME/.opencode/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Machine-specific and private bits (not in the repo)
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
