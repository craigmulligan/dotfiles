set -e

# needed for add-apt-repository
sudo apt-get update -y && \
  sudo apt-get install -y software-properties-common

sudo apt-get update -y && \
  sudo apt-get install -y git \
  make \
  curl \
  zsh \
  jq \
  mutt \
  msmtp \
  xclip \
  docker.io \
  w3m \
  python3 \
  python3-pip \
  qrencode \
  whois \
  bat


# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search

# Latest Node
curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -
sudo apt-get install -y nodejs

# Global node modules
sudo npm i --global eslint

sudo groupadd docker && sudo usermod -aG docker $USER
sudo usermod -aG docker $USER
newgrp docker

# Install zsh system clip plugin
git clone https://github.com/kutsan/zsh-system-clipboard ~/.zsh/plugins/zsh-system-clipboard

# python utils
pip3 install --user flake8 black

# Golang
curl -O https://golang.org/dl/go1.15.5.linux-amd64.tar.gz && tar -C /usr/local -xzf go1.15.5.linux-amd64.tar.gz


# curl https://raw.githubusercontent.com/dracula/zsh/master/dracula.zsh-theme > ~/.oh-my-zsh/themes/dracula.zsh-theme
# mkdir -p ~/.oh-my-zsh/themes/lib
# curl https://raw.githubusercontent.com/dracula/zsh/master/lib/async.zsh > ~/.oh-my-zsh/themes/lib/async.zsh
