# Deps
apt-get update && apt-get install git make curl zsh vim-gnome python nodejs npm docker jq ack-grep mutt tmux w3m todotxt-cli ispell urlview offlineimap msmtp
# oh-my-zsh 
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

npm i -g yarn n
# Install nightly node v
n latest
