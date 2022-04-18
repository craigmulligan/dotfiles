set -e

# Install neovim
curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
chmod u+x nvim.appimage
cp nvim.appimage $HOME/.local/bin/nvim
rm ./nvim.appimage

# Install lvim
bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)
