#!/bin/bash

# Function to install zsh
install_zsh() {
  echo "Installing zsh..."
  if command -v apt > /dev/null; then
    sudo apt update && sudo apt install -y zsh
  elif command -v apt-get > /dev/null; then
    sudo apt-get update && sudo apt-get install -y zsh
  elif command -v snap > /dev/null; then
    sudo snap install zsh --classic
  else
    echo "Package manager not supported. Please install zsh manually."
  fi
  echo "zsh installed!"
}

# Function to make zsh the default shell
make_zsh_default() {
  echo "Making zsh the default shell..."
  chsh -s $(which zsh)
  echo "zsh is now the default shell. Please log out and log back in for the changes to take effect."
}

# Function to install oh-my-zsh
install_oh_my_zsh() {
  echo "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  echo "oh-my-zsh installed!"
}

# Function to install zsh plugins
install_zsh_plugins() {
  echo "Installing zsh plugins..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
  git clone https://github.com/junegunn/fzf.git ~/.oh-my-zsh/custom/plugins/fzf
  ~/.oh-my-zsh/custom/plugins/fzf/install --all
  git clone https://github.com/zdharma-continuum/fast-syntax-highlighting ~/.oh-my-zsh/custom/plugins/fast-syntax-highlighting
  git clone https://github.com/unixorn/fzf-zsh-plugin ~/.oh-my-zsh/custom/plugins/fzf-zsh-plugin
  git clone https://github.com/popstas/zsh-command-time ~/.oh-my-zsh/custom/plugins/command-time
  echo "zsh plugins installed!"
}

# Function to install nvm
install_nvm() {
  echo "Installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | zsh
  # Load nvm and install the latest stable node

  export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

  nvm install --lts
  echo "nvm installed!"
}

# Function to install fzf
install_fzf() {
  echo "Installing fzf..."
  sudo apt install -y fzf
  echo "fzf installed!"
}

# Function to install tmux
install_tmux() {
  echo "Installing tmux..."
  if command -v apt > /dev/null; then
    sudo apt update && sudo apt install -y tmux
  elif command -v apt-get > /dev/null; then
    sudo apt-get update && sudo apt-get install -y tmux
  elif command -v snap > /dev/null; then
    sudo snap install tmux
  else
    echo "Package manager not supported. Please install tmux manually."
  fi
  echo "tmux installed!"
}

# Function to install nvim
install_nvim() {
  echo "Installing nvim..."
  if command -v apt > /dev/null; then
    sudo apt update && sudo apt install -y neovim
  elif command -v apt-get > /dev/null; then
    sudo apt-get update && sudo apt-get install -y neovim
  elif command -v snap > /dev/null; then
    sudo snap install nvim --classic
  else
    echo "Package manager not supported. Please install nvim manually."
  fi
  echo "nvim installed!"
}

# Function to install pnpm
install_pnpm() {
  echo "Installing pnpm..."
  curl -fsSL https://get.pnpm.io/install.sh | sh -
  echo "pnpm installed!"
}

# Function to install yarn
install_yarn() {
  echo "Installing yarn..."
  if command -v npm > /dev/null; then
    npm install -g yarn
  else
    echo "Npm not found. Please install to proceed."
  fi
  echo "yarn installed!"
}

# Function to install bun
install_bun() {
  echo "Installing bun..."
  curl -fsSL https://bun.sh/install | bash
  echo "bun installed!"
}

# Function to install go
install_go() {
  echo "Installing Go..."
  if command -v apt > /dev/null; then
    sudo apt update && sudo apt install -y golang-go
  elif command -v apt-get > /dev/null; then
    sudo apt-get update && sudo apt-get install -y golang-go
  else
    echo "Package manager not supported. Please install Go manually."
  fi
  echo "Go installed!"
}

# Function to install TypeScript globally
install_typescript() {
  echo "Installing TypeScript globally..."
  npm install -g typescript
  echo "TypeScript installed globally!"
}

# Function to install Docker
install_docker() {
  echo "Installing Docker..."

  sudo apt-get update
  sudo apt-get install ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  # Add the repository to Apt sources:
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sudo usermod -aG docker $USER
  echo "Docker installed!"
}

# Function to install MySQL
install_mysql() {
  echo "Installing MySQL..."
  sudo apt update
  sudo apt install -y mysql-server
  echo "MySQL installed!"
}

install_stow() {
  echo "Installing stow..."
  sudo apt install -y stow
  echo "stow installed!"
}

symlink() {
  echo "Symlinking with stow"
  stow .
  echo "Symlinking done!"
}

# Run the functions
install_zsh
make_zsh_default
install_oh_my_zsh
install_zsh_plugins
install_nvm
install_fzf
install_tmux
install_nvim
install_pnpm
install_yarn
install_bun
install_go
install_typescript
install_docker
install_mysql
install_stow

echo "All tools and plugins installed successfully! Please log out and log back in for 'Making zsh' to become the default shell."

symlink

echo "Symlinking done!"
