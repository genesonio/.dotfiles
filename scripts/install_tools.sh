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
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash  # Load nvm and install the latest stable node

  nvm install --lts
  nvm use --lts
  echo "nvm installed!"
}

# Function to install fzf
install_fzf() {
  echo "Installing fzf..."
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
  echo "fzf installed!"
}

install_grep() {
  echo "Installing ripgrep"
  sudo apt install ripgrep
  echo "Ripgreg installed"
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
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
  sudo rm -rf /opt/nvim
  sudo tar -C /opt -xzf nvim-linux64.tar.gz 
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

# Function to install TypeScript globally
install_typescript() {
  echo "Installing TypeScript globally..."
  npm install -g typescript
  echo "TypeScript installed globally!"
}

# Function to install Docker
install_docker() {
  echo "Installing Docker..."
  if command -v apt > /dev/null; then
    sudo apt install docker-compose
  elif command -v snap > /dev/null; then
    sudo snap install docker
  else
    echo "Package manager not supported. Please install docker manually."
  fi
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

# Run the functions
install_zsh
make_zsh_default
install_oh_my_zsh
install_zsh_plugins
install_nvm
install_fzf
install_grep
install_tmux
install_nvim
install_pnpm
install_yarn
install_bun
install_typescript
install_docker
install_mysql
install_stow

echo "All tools and plugins installed successfully! Please log out and log back in for 'Making zsh' to become the default shell."

echo "Install nerd fonts"
