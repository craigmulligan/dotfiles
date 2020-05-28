# needed for add-apt-repository
sudo apt-get update -y && \
  sudo apt-get install -y software-properties-common

# Add third-party repos
sudo add-apt-repository ppa:jonathonf/vim

# Deps
sudo apt-get update -y && \
  sudo apt-get install -y git \
  make \
  curl \
  zsh \
  vim \
  vim-gtk \
  python \
  jq \
  mutt \
  offlineimap \
  msmtp \
  tmux \
  xclip \
  silversearcher-ag \
  lastpass-cli \
  docker.io

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search

# Latest Node
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs

sudo groupadd docker && sudo usermod -aG docker $USER
