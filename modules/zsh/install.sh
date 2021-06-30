set -e

curl https://raw.githubusercontent.com/dracula/zsh/master/dracula.zsh-theme > ~/.oh-my-zsh/themes/dracula.zsh-theme
mkdir -p ~/.oh-my-zsh/themes/lib
curl https://raw.githubusercontent.com/dracula/zsh/master/lib/async.zsh > ~/.oh-my-zsh/themes/lib/async.zsh
