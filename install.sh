# Deps
sudo apt-get update && \
  apt-get install git \
  make \
  curl \
  zsh \
  vim \
  python \
  nodejs \
  npm \
  jq \
  mutt \
  tmux \
  w3m \
  todotxt-cli \
  ispell \
  urlview \
  offlineimap \
  msmtp \
  tmux \
  xclip
  vim-gtk

git clone https://github.com/jimeh/tmux-themepack.git ~/.tmux-themepack

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install docker
sh -c "$(curl -sSL https://get.docker.com/)"

git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
