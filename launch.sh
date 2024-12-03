#!/usr/bin/env bash

# Define home directory
HOME_DIR="$HOME"

# Update and upgrade system packages
sudo apt update && sudo apt full-upgrade -y
sudo apt autoremove -y && sudo apt autoclean -y

# Install packages from pkg.txt
packages=$(awk '!/^#/ && NF {print $1}' $HOME_DIR/debian/files/pkg.txt)
echo "$packages" | xargs sudo apt install -y

# Configure environment files
cp $HOME_DIR/debian/files/.zshrc $HOME_DIR/
cp $HOME_DIR/debian/files/.gitconfig $HOME_DIR/
cp $HOME_DIR/debian/files/.tmux.conf $HOME_DIR/

# Install Zsh and Zinit
chsh -s $(which zsh)
bash -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma-continuum/zinit/main/scripts/install.sh)"

# Install Rust and Rust Analyzer
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
export PATH="$HOME/.cargo/bin:$PATH"
source ~/.profile
rustup component add rust-analyzer

# Install Neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz

# Install NvChad for Neovim
git clone https://github.com/NvChad/starter ~/.config/nvim
cp -r $HOME_DIR/debian/custom/ $HOME_DIR/.config/nvim/lua/

# Switch to Zsh
exec /bin/zsh