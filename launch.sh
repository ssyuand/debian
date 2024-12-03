#!/usr/bin/env bash
HOME_DIR="$HOME"
sudo apt update && sudo apt full-upgrade -y
sudo apt autoremove -y && sudo apt autoclean -y
# Read each package name from pkg.txt and install them one by one
packages=$(awk '!/^#/ && NF {print $1}' $HOME_DIR/debian/files/pkg.txt)
echo "$packages" | xargs sudo apt install -y
# Environment configuration
cp $HOME_DIR/debian/files/.zshrc $HOME_DIR/
cp $HOME_DIR/debian/files/.gitconfig $HOME_DIR/
cp $HOME_DIR/debian/files/.tmux.conf $HOME_DIR/

#zsh
chsh -s $(which zsh)
bash -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma-continuum/zinit/main/scripts/install.sh)"

#rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
export PATH="$HOME/.cargo/bin:$PATH"
source ~/.profile
rustup component add rust-analyzer

#neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz

#nvchad
git clone https://github.com/NvChad/starter ~/.config/nvim 
cp -r $HOME_DIR/debian/custom/ $HOME_DIR/.config/nvim/lua/
