# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# export PATH="$HOME/bin:$PATH";
export PATH="$HOME/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
export PATH="/usr/local/opt/openssl/bin:$PATH"
export PATH="$HOME/sessionmanager-bundle/bin:$PATH"
# export PATH="$PATH:~/.local/bin"
export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="/usr/local/opt/mysql-client/bin:$PATH"

# Go exports
export GOPATH=$HOME/Documents/projects/go
export GOROOT=/usr/local/opt/go/libexec
export GOBIN="$GOPATH/bin"
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin


HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/Users/mcuber/.zshrc'

# zstyle ':completion:*:ssh:*' hosts off
# zstyle ':completion:*:ssh:*' config on

# Path to your oh-my-zsh installation.
export ZSH="/Users/mcuber/.oh-my-zsh"

# required for GPG signing when gnupg2 and gpg-agent 2.x are used
export GPG_TTY=$(tty)
# required to fix issues with kubectl
export KUBE_EDITOR="vim"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="bureau"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

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
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  docker
  git
  nmap
  ssh-agent
  terraform
  zsh-completions
)

autoload -Uz compinit
compinit

source $ZSH/oh-my-zsh.sh

setopt hist_ignore_all_dups # remove older duplicate entries from history
setopt hist_reduce_blanks # remove superfluous blanks from history items
setopt inc_append_history # save history entries as soon as they are entered
setopt share_history # share history between different instances of the shell
setopt auto_list # automatically list choices on ambiguous completion
setopt auto_menu # automatically use menu completion
setopt always_to_end # move cursor to end if word had one match

export NVM_DIR="${HOME}/.nvm"
[[ -s "${NVM_DIR}/nvm.sh" ]] && \. "${NVM_DIR}/nvm.sh"  # This loads nvm

[[ -s "${HOME}/.rvm/scripts/rvm" ]] && source "${HOME}/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Load the shell dotfiles, and then some:
for file in ~/.{aws_aliases,aliases,functions,ssl_functions,aws_functions.d/functions}; do
  [[ -r "$file" ]] && [[ -f "$file" ]] && source "$file";
done;
unset file;

source <(aws-okta completion zsh) # aws-okta cli autocompletion
source <(kubectl completion zsh) # kubectl cli autocompletion

# auto-completion saml2aws
eval "$(saml2aws --completion-script-zsh)"

# akamai cli autocompletion
autoload -U compinit && compinit
autoload -U bashcompinit && bashcompinit
_akamai_cli_bash_autocomplete() {
    local cur opts base
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    opts=$( ${COMP_WORDS[@]:0:$COMP_CWORD} --generate-auto-complete )
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}

complete -F _akamai_cli_bash_autocomplete akamai

# Fun
neofetch --ascii "$(fortune -o |cowsay -W 50)" |lolcat

zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

# nr1 autocomplete setup
NR1_AC_ZSH_SETUP_PATH=/Users/mcuber/Library/Caches/newrelic-cli/autocomplete/zsh_setup && test -f ${NR1_AC_ZSH_SETUP_PATH} && source ${NR1_AC_ZSH_SETUP_PATH};export PATH="/usr/local/opt/python@3.8/bin:$PATH"
