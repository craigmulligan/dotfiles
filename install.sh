# https://github.com/docker/for-linux/issues/833
# Docker + ubuntu 19 issue
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   disco \
   stable"

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
  xclip \
  vim-gtk \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  silversearcher-ag

git clone https://github.com/jimeh/tmux-themepack.git ~/.tmux-themepack

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

wget https://github.com/containerd/containerd/releases/download/v1.3.0/containerd-1.3.0.linux-amd64.tar.gz
tar xvf containerd-1.3.0.linux-amd64.tar.gz
wget "https://download.docker.com/linux/ubuntu/dists/disco/pool/stable/amd64/docker-ce-cli_19.03.3~3-0~ubuntu-disco_amd64.deb"
wget "https://download.docker.com/linux/ubuntu/dists/disco/pool/stable/amd64/docker-ce_19.03.3~3-0~ubuntu-disco_amd64.deb"
sudo apt install "containerd-1.3.0.linux-amd64.deb"
sudo apt install "docker-ce-cli_19.03.3~3-0~ubuntu-disco_amd64.deb"
sudo apt install "docker-ce_19.03.3~3-0~ubuntu-disco_amd64.deb"

git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search


sudo groupadd docker && sudo usermod -aG docker $USER
