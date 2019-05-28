# Deps
apt-get update && apt-get install git make curl zsh vim-gnome python nodejs npm docker jq mutt tmux w3m todotxt-cli ispell urlview offlineimap msmtp linux-image-extra-$(uname -r) linux-image-extra-virtual tmux silversearcher-ag

git clone https://github.com/jimeh/tmux-themepack.git ~/.tmux-themepack

# Install docker
sh -c "$(curl -sSL https://get.docker.com/)"

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search

npm i -g yarn n
yarn global add gratitude
# Install nightly node v
n latest

# https://askubuntu.com/questions/715104/how-can-i-downgrade-openssl-via-apt-get?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
# Downgrade openssl to version 1.0.x
wget https://launchpad.net/~ubuntu-security/+archive/ubuntu/ppa/+build/7531893/+files/openssl_1.0.1-4ubuntu5.31_amd64.deb
sudo dpkg -i openssl_1.0.1-4ubuntu5.31_amd64.deb
