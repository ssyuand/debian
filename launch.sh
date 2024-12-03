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

#nvchad
git clone https://github.com/NvChad/NvChad $HOME_DIR/.config/nvim --depth 1
cp -r ~/debian/files/custom/ ~/.config/nvim/lua/

#zsh
chsh -s $(which zsh)
bash -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma-continuum/zinit/main/scripts/install.sh)"
