##############
# BASIC SETUP
##############

typeset -U PATH
autoload colors; colors;

#############
## PRIVATE ##
#############
# Include private stuff that's not supposed to show up
# in the dotfiles repo
local private="${HOME}/.zsh.d/private.sh"
if [ -r ${private} ]; then
  . ${private}
fi

##########
# HISTORY
##########

HISTFILE=$HOME/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

setopt EXTENDED_HISTORY
setopt HIST_VERIFY
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Dont record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Dont record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Dont write duplicate entries in the history file.

setopt inc_append_history
setopt share_history

#############
# COMPLETION
#############

# Add completions installed through Homebrew packages
# See: https://docs.brew.sh/Shell-Completion
if type brew &>/dev/null; then
  FPATH=/usr/local/share/zsh/site-functions:$FPATH
fi

autoload -U compinit
compinit -i

unsetopt menu_complete
unsetopt flowcontrol
setopt prompt_subst
setopt auto_menu
setopt complete_in_word
setopt always_to_end
setopt auto_pushd
zmodload -i zsh/complist

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' special-dirs true
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH/cache/
zstyle ':completion:*:*:*:*:*' menu select

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"

# use /etc/hosts and known_hosts for hostname completion
[ -r ~/.ssh/known_hosts ] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
[ -r ~/.ssh/config ] && _ssh_config=($(cat ~/.ssh/config | sed -ne 's/Host[=\t ]//p')) || _ssh_config=()
[ -r /etc/hosts ] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()
hosts=(
  "$_ssh_config[@]"
  "$_global_ssh_hosts[@]"
  "$_ssh_hosts[@]"
  "$_etc_hosts[@]"
  "$HOST"
  localhost
)
zstyle ':completion:*:hosts' hosts $hosts
zstyle ':completion:*' users off

###############
# KEY BINDINGS
###############

# Vim Keybindings
bindkey -v

# Open line in Vim by pressing 'v' in Command-Mode
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Push current line to buffer stack, return to PS1
bindkey "^Q" push-input

# Make up/down arrow put the cursor at the end of the line
# instead of using the vi-mode mappings for these keys
bindkey "\eOA" up-line-or-history
bindkey "\eOB" down-line-or-history
bindkey "\eOC" forward-char
bindkey "\eOD" backward-char

# CTRL-R to search through history
bindkey '^R' history-incremental-search-backward
# CTRL-S to search forward in history
bindkey '^S' history-incremental-search-forward
# Accept the presented search result
bindkey '^Y' accept-search

# Use the arrow keys to search forward/backward through the history,
# using the first word of what's typed in as search word
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Use the same keys as bash for history forward/backward: Ctrl+N/Ctrl+P
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward

# Backspace working the way it should
bindkey '^?' backward-delete-char
bindkey '^[[3~' delete-char

# Some emacs keybindings won't hurt nobody
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

#########
# Aliases
#########

local aliasfile="${HOME}/.zsh.d/aliases.`uname`.sh"
if [ -r ${aliasfile} ]; then
  source ${aliasfile}
fi

alias lls='ls -lh --sort=size --reverse'
alias llt='ls -l -t -r'
alias bear='clear && echo "Clear as a bear!"'

alias history='history 1'
alias hs='history | grep '

# Use rsync with ssh and show progress
alias rsyncssh='rsync -Pr --rsh=ssh'

# Edit/Source vim config
alias ez='vim ~/.zshrc'
alias sz='source ~/.zshrc'

# git
alias gst='git status'
alias gaa='git add -A'
alias gd='git diff'
alias gdc='git diff --cached'
# Go way, Ghostscript
alias gs='gst'
alias gp='git push'

# ruby & rails
alias be='bundle exec'

# Screen
alias screen='screen -R -D'

# tmux
alias tma='tmux attach -t'
alias tmn='tmux new -s'

# ceedee dot dot dot
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

# fzz and ag
alias fazz='fzz ag -i {{}}'
# fzz and find
alias fizz='fzz find . -iname "*{{}}*"'

# Notes
alias n='vim +Notes' # Opens Vim and calls `:Notes`

# Go
alias got='go test ./...'

alias scr='vim ~/tmp/scratch.md'

##########
# FUNCTIONS
##########

startpostgres() {
  local pidfile="/usr/local/var/postgres/postmaster.pid"
  if [ -s $pidfile ] && kill -0 $(cat $pidfile | head -n 1) > /dev/null 2>&1; then
    echo "Already running"
  else
    pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start
  fi
}

stoppostgres() {
  pg_ctl -D /usr/local/var/postgres stop
}

# Taken from here: http://timbabwe.com/2012/05/iterm_tab_and_window_titles_with_zsh
# precmd () {
#   tab_label=${PWD/${HOME}/\~} # use 'relative' path
#   echo -ne "\e]2;${tab_label}\a" # set window title to full string
#   echo -ne "\e]1;${tab_label: -24}\a" # set tab title to rightmost 24 characters
# }

mkdircd() {
  mkdir -p $1 && cd $1
}

serve() {
  local port=${1:-8000}
  local ip=$(ipconfig getifaddr en0)
  echo "Serving on ${ip}:${port} ..."
  python -m SimpleHTTPServer ${port}
}

beautiful() {
  while
  do
    i=$((i + 1)) && echo -en "\x1b[3$(($i % 7))mo" && sleep .2
  done
}

spinner() {
  while
  do
    for i in "-" "\\" "|" "/"
    do
      echo -n " $i \r\r"
      sleep .1
    done
  done
}

s3() {
  local route="s3.thorstenball.com/${1}"
  aws s3 cp ${1} s3://${route}
  echo http://${route} | pbcopy
}

vimfzz() {
  exec vim $(fzz ag {{}} ${1} | awk -F":" '{print $1}' | uniq)
}

cdfzz() {
  local file=$(fzz find . -iname "*{{}}*" | head -n 1)
  local filedir=$(dirname ${file})
  cd ${filedir}
}

f() {
  find . -iname "*${1}*"
}

#########
# PROMPT
#########

git_prompt_info() {
  local dirstatus=" OK"
  local dirty="%{$fg_bold[red]%} X%{$reset_color%}"

  if [[ ! -z $(git status --porcelain 2> /dev/null | tail -n1) ]]; then
    dirstatus=$dirty
  fi

  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo "%{$fg_bold[green]%}${ref#refs/heads/}$dirstatus%{$reset_color%}"
}

# local dir_info_color="$fg_bold[black]"

# This just sets the color to "bold".
# Future me. Try this to see what's correct:
#   $ print -P '%fg_bold[black] black'
#   $ print -P '%B%F{black} black'
#   $ print -P '%B black'         
local dir_info_color="%B"

local dir_info_color_file="${HOME}/.zsh.d/dir_info_color"
if [ -r ${dir_info_color_file} ]; then
  source ${dir_info_color_file}
fi

local dir_info="%{$dir_info_color%}%(5~|%-1~/.../%2~|%4~)%{$reset_color%}"
local promptnormal="%{$fg_bold[grey]%}λ %{$reset_color%}"
local promptjobs="%{$fg_bold[red]%}λ %{$reset_color%}"

# PROMPT='${dir_info} %{$fg_bold[grey]%}`rbenv version-name`%{$reset_color%} $(git_prompt_info) %(1j.$promptjobs.$promptnormal)'
PROMPT='${dir_info} $(git_prompt_info) %(1j.$promptjobs.$promptnormal)'

########
# ENV
########

if which nvim &> /dev/null; then
  alias vim='nvim'
  export EDITOR='nvim'
  export PSQL_EDITOR='nvim -c"set filetype=sql"'
  export GIT_EDITOR='nvim'
else
  export EDITOR='vim'
  export PSQL_EDITOR='vim -c"set filetype=sql"'
  export GIT_EDITOR='vim'
fi

local envfile="${HOME}/.zsh.d/env.`uname`.sh"
if [ -r ${envfile} ]; then
  . ${envfile}
fi

export PATH="$HOME/bin:$PATH"

export LSCOLORS="Gxfxcxdxbxegedabagacad"

# Reduce delay for key combinations in order to change to vi mode faster
# See: http://www.johnhawthorn.com/2012/09/vi-escape-delays/
# Set it to 10ms
export KEYTIMEOUT=1

# homebrew
export PATH="/usr/local/bin:$PATH"

# rbenv
if which rbenv &> /dev/null; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init - --no-rehash)"
fi

# asdf
if [ -f /usr/local/opt/asdf/asdf.sh ]; then
  source /usr/local/opt/asdf/asdf.sh
  source /usr/local/opt/asdf/etc/bash_completion.d/asdf.bash
fi


# Encoding problems with gem
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# node.js
export NODE_PATH="/usr/local/lib/node_modules:$NODE_PATH"

# golang
export GOPATH="$HOME/code/go"
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:$PATH"

#heroku
export PATH="/usr/local/heroku/bin:$PATH"

# direnv
if which direnv &> /dev/null; then
  eval "$(direnv hook zsh)"
fi

# fzf
# fzf via Homebrew
if [ -e /usr/local/opt/fzf/shell/completion.zsh ]; then
  source /usr/local/opt/fzf/shell/key-bindings.zsh
  source /usr/local/opt/fzf/shell/completion.zsh
fi

# fzf via local installation
if [[ ! "$PATH" == */home/mrnugget/.fzf/bin* ]]; then
  export PATH="$PATH:/home/mrnugget/.fzf/bin"
fi
if [ -e ~/.fzf ]; then
  source ~/.fzf/shell/key-bindings.zsh
  source ~/.fzf/shell/completion.zsh
fi

if which fzf &> /dev/null && which rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*" --glob "!vendor/*"'
  export FZF_CTRL_T_COMMAND='rg --files --hidden --follow --glob "!.git/*" --glob "!vendor/*"'
  export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_DEFAULT_OPTS='
    --color=bg+:#DEECF9,bg:#FFFFFF,spinner:#3f5fff,hl:#586e75
    --color=fg:#839496,header:#586e75,info:#cb4b16,pointer:#3f5fff
    --color=marker:#3f5fff,fg+:#839496,prompt:#3f5fff,hl+:#3f5fff'
fi

# rust
export PATH="$HOME/.cargo/bin:$PATH"
if which rustc &> /dev/null; then
  export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
fi

# python
if which pyenv &> /dev/null; then
  eval "$(pyenv init -)"
  export PATH="$HOME/.local/bin:$PATH"
fi

# Deactive this until this is fixed: https://github.com/BurntSushi/ripgrep/issues/375
if which rg &> /dev/null; then
  compdef -d rg
  alias gr='rg' # Because in Vim you `:gr[ep]`
fi
export PATH="/usr/local/opt/curl/bin:$PATH"

# Try out `z`
if [ -e /usr/local/etc/profile.d/z.sh ]; then
  source /usr/local/etc/profile.d/z.sh 
fi

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
