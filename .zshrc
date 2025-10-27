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
ZSH_THEME="robbyrussell"

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

plugins=(git zsh-syntax-highlighting zsh-autosuggestions fzf aliases colorize command-not-found battery emoji-clock lol)

source $ZSH/oh-my-zsh.sh

source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

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

# alias air="/home/genesio/go/bin/air"

# alias templ="/home/genesio/go/bin/templ"

alias wbr="pkill waybar && hyprctl dispatch exec waybar"

bye() {
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
  nvim ~/.config/hypr/hyprland.conf
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
    elif [ -f pnpm-lock.yaml ]; then
        pnpm "$@"
    elif [ -f bun.lockb ]; then
        bun "$@"
    fi
}

dpm() {
    if [ -f yarn.lock ]; then
        doppler run -- yarn "$@"
    elif [ -f pnpm-lock.yaml ]; then
        doppler run -- pnpm "$@"
    elif [ -f package-lock.json ]; then
        doppler run -- npm "$@"
    elif [ -f pnpm-lock.yaml ]; then
        doppler run -- pnpm "$@"
    elif [ -f bun.lockb ]; then
        doppler run -- bun "$@"
    else
      echo "No package manager found"
    fi
}

cdp() {
    selected=$(find ~/Github -mindepth 1 -maxdepth 1 -type d | fzf --preview 'ls {}' --query "$1" --print0 --select-1)
    cd $selected
}

cdd() {
    selected=$(find ~/Dockers -mindepth 1 -maxdepth 1 -type d | fzf --preview 'ls {}' --query "$1" --print0 --select-1)
    cd $selected
}

vp() {
    selected=$(find ~/Github -mindepth 1 -maxdepth 1 -type d | fzf --preview 'ls {}' --query "$1" --print0 --select-1)
    cd $selected
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

ngroks() {
  ngrok http --url=large-squirrel-allowed.ngrok-free.app "$@"
}

ngroksd() {
  ngrok http --url=amazingly-ruling-crawdad.ngrok-free.app "$@"
}

jcurl() {
    curl $@ | jq
}

sshl() {
  ssh -i ~/.ssh/learnistic "$@"
}

dot() {
    cd ~/.dotfiles
    nvim .
}

lrn() {
  export GIT_SSH_COMMAND="ssh -i ~/.ssh/learnistic -o IdentitiesOnly=yes"
}

git() {
  if [ "$1" = fetch ]; then
    shift
    set -- fetch --all "$@"
  fi
  command git "$@"
}

cam() {
  # require adb
  command -v adb >/dev/null 2>&1 || { echo "adb not found"; return 1; }

  # build list: <serial>\t<full line> so we can cut the serial after selection
  local choice serial
  choice=$(adb devices -l | tail -n +2 | awk 'NF{print $1"\t"$0}' \
    | fzf --height=40% --ansi \
          --preview 'adb -s {1} shell getprop ro.product.model 2>/dev/null || true' \
          --preview-window=right:50% \
          --prompt="Select device: ") || return 1

  serial=$(printf '%s' "$choice" | cut -f1)
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
    --v4l2-sink=/dev/video0 \
    --no-window \
    --no-audio \
    --no-playback
}

bindkey -s ^f "tmux-sessionizer\n"
bindkey -s ^g "tmux-session-fzf\n"
bindkey -s ^k "tmux kill-session\n"

eval "$(starship init zsh)"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Turso
export PATH="/home/genesio/.turso:$PATH"

# bun completions
[ -s "/home/genesio/.bun/_bun" ] && source "/home/genesio/.bun/_bun"

# pnpm
export PNPM_HOME="/home/genesio/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
