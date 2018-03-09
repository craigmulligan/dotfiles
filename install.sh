# Deps
apt-get update && apt-get install git make curl zsh vim-gnome python nodejs npm docker jq mutt tmux w3m todotxt-cli ispell urlview offlineimap msmtp linux-image-extra-$(uname -r) linux-image-extra-virtual

# Install docker
sh -c "$(curl -sSL https://get.docker.com/)"

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search

npm i -g yarn n
yarn global add gratitude
# Install nightly node v
n latest
