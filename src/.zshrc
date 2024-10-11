eval "$(/opt/homebrew/bin/brew shellenv)"
if [ "$TMUX" = "" ]; then tmux -u; fi
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="shades-of-purple"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
##################################################
# Settings
##################################################

# https://gist.github.com/ctechols/ca1035271ad134841284
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
	compinit;
else
	compinit -C;
fi;

export AUTOSWITCH_DEFAULT_PYTHON=python3.11

plugins=(
  git
  history-substring-search
  zsh-completions
  wd
  # autoswitch_virtualenv
)
fpath+=~/.zfunc

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
export LANG=en_US.UTF-8

export EDITOR=nvim
export VISUAL=nvim

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

##################################################
# Aliases
##################################################


alias reload="omz reload"
alias ll="ls -l"
alias tele="telepresence"
alias kop='function _kill_on_port(){ fuser -k $1/tcp };_kill_on_port'
alias xclip='xclip -sel clip'
alias pom="sleep 2500 && zenity --warning --text='25 minutes passed'"
alias lg="pkill -KILL -u hobochild"
alias qr="qrencode"
alias clip2qr="xclip -out -sel clip | qrencode -t UTF8"
# Open current repo in browser
alias ghv="gh repo view --web"
alias vol="pavucontrol"
alias cpr="copyq read"
# alias nvim="lvim"
alias vi="nvim"
alias iv="nvim"
# latest git branchs
alias gbs='git branch --sort=-committerdate'
alias pm='pnpm'

# Modern tools
alias bcat="batcat"
alias svenv="source .venv/bin/activate"

# Make sure pipenv global dir is findable
export PATH="${HOME}/.local/bin:$PATH"
export PATH=$PATH:~/Play/bump
export PATH=$PATH:~/Play/lil
export PATH=$PATH:/usr/local/go/bin
export GOPATH="$HOME/go"
export PATH="${GOPATH}/bin:$PATH"
export PATH="$PATH:$HOME/.poetry/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:/usr/lib/dart/bin"
export PATH="$PATH":"$HOME/.pub-cache/bin"
export PATH="$PATH:$HOME/.gem/ruby/3.0.0/bin"

bindkey -v
# Make the escape mode the same as in vim.
bindkey jk vi-cmd-mode
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'vv' edit-command-line

export $(cat $HOME/.env | xargs)

# Needed for docker dbus permissions
export PATH="$PATH:$HOME/.local/bin"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"


# pnpm
export PNPM_HOME="/Users/craigmulligan/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/craigmulligan/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/craigmulligan/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/craigmulligan/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/craigmulligan/google-cloud-sdk/completion.zsh.inc'; fi

autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

export ZEIT_DB=~/.config/zeit.db
export PATH=$PATH:$HOME/.maestro/bin
# Added by LM Studio CLI tool (lms)
export PATH="$PATH:/Users/craigmulligan/.cache/lm-studio/bin"
export PATH="/opt/homebrew/opt/mysql-client@8.4/bin:$PATH"
