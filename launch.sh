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
git clone https://github.com/neovim/neovim.git && cd neovim
make CMAKE_BUILD_TYPE=Release
sudo make install

# Waydroid
sudo apt install curl ca-certificates -y
curl https://repo.waydro.id | sudo bash
sudo apt install waydroid -y
sudo waydroid init -s GAPPS -f
sudo sed -i~ -E 's/=.\$\(command -v (nft|ip6?tables-legacy).*/=/g' \
     /usr/lib/waydroid/data/scripts/waydroid-net.sh

# Waydroid add ibndk & libhoudini and Search Google Play Certification to cetified.
sudo apt-get install python3.11-venv lzip

git clone https://github.com/casualsnek/waydroid_script
cd waydroid_script
python3 -m venv venv
venv/bin/pip install -r requirements.txt
sudo venv/bin/python3 main.py

sudo venv/bin/python3 main.py install libhoudini
sudo venv/bin/python3 main.py install widevine


# Install NvChad for Neovim
git clone https://github.com/NvChad/starter ~/.config/nvim
cp -r $HOME_DIR/debian/custom/ $HOME_DIR/.config/nvim/lua/

# Switch to Zsh
exec /bin/zsh
