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
if [ -e ${private} ]; then
  . ${private}
fi

##########
# HISTORY
##########

HISTFILE=$HOME/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

setopt INC_APPEND_HISTORY     # Immediately append to history file.
setopt EXTENDED_HISTORY       # Record timestamp in history.
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS       # Dont record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS   # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS      # Do not display a line previously found.
setopt HIST_IGNORE_SPACE      # Dont record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS      # Dont write duplicate entries in the history file.
setopt SHARE_HISTORY          # Share history between all sessions.
unsetopt HIST_VERIFY          # Execute commands using history (e.g.: using !$) immediately

#############
# COMPLETION
#############

# Add completions installed through Homebrew packages
# See: https://docs.brew.sh/Shell-Completion
if type brew &>/dev/null; then
  FPATH=/usr/local/share/zsh/site-functions:$FPATH
fi

# Speed up completion init, see: https://gist.github.com/ctechols/ca1035271ad134841284
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

# unsetopt menucomplete
unsetopt flowcontrol
setopt auto_menu
setopt complete_in_word
setopt always_to_end
setopt auto_pushd

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

###############
# KEY BINDINGS
###############

# Vim Keybindings
bindkey -v

# This is a "fix" for zsh in Ghostty:
# Ghostty implements the fixterms specification https://www.leonerd.org.uk/hacks/fixterms/
# and under that `Ctrl-[` doesn't send escape but `ESC [91;5u`.
#
# (tmux and Neovim both handle 91;5u correctly, but raw zsh inside Ghostty doesn't)
#
# Thanks to @rockorager for this!
bindkey "^[[91;5u" vi-cmd-mode

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

# Where should I put you?
bindkey -s '^F' "tmux-sessionizer\n"

#########
# Aliases
#########

case $OSTYPE in
  linux*)
    local aliasfile="${HOME}/.zsh.d/aliases.Linux.sh"
    [[ -e ${aliasfile} ]] && source ${aliasfile}
  ;;
  darwin*)
    local aliasfile="${HOME}/.zsh.d/aliases.Darwin.sh"
    [[ -e ${aliasfile} ]] && source ${aliasfile}
  ;;
esac

if type lsd &> /dev/null; then
  alias ls=lsd
fi
alias lls='ls -lh --sort=size --reverse'
alias llt='ls -lrt'
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
alias s='git status'
alias gaa='git add -A'
alias gcm='git checkout main'
alias gd='git diff'
alias gdc='git diff --cached'
# [c]heck [o]ut
alias co='git checkout'
# [f]uzzy check[o]ut
fo() {
  git branch --no-color --sort=-committerdate --format='%(refname:short)' | fzf --header 'git checkout' | xargs git checkout
}
# [p]ull request check[o]ut
po() {
  gh pr list --author "@me" | fzf --header 'checkout PR' | awk '{print $(NF-5)}' | xargs git checkout
}
alias up='git push'
alias upf='git push --force'
alias pu='git pull'
alias pur='git pull --rebase'
alias fe='git fetch'
alias re='git rebase'
alias lr='git l -30'
alias cdr='cd $(git rev-parse --show-toplevel)' # cd to git Root
alias hs='git rev-parse --short HEAD'
alias hm='git log --format=%B -n 1 HEAD'

# jj experiment warnings
gc() {
  echo "⚠️  You're trying out jj this week! Use 'jj commit' instead of 'gc'"
  echo "   (or run 'command git commit' to bypass this warning)"
}

git() {
  if [[ "$1" == "commit" ]]; then
    echo "⚠️  You're trying out jj this week! Use 'jj commit' instead of 'git commit'"
    echo "   (or run 'command git commit' to bypass this warning)"
  else
    command git "$@"
  fi
}

# tmux
alias tma='tmux attach -t'
alias tmn='tmux new -s'
alias tmm='tmux new -s main'

# ceedee dot dot dot
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

# Notes
alias n='vim +Notes' # Opens Vim and calls `:Notes`

# Go
alias got='go test ./...'

alias k='kubectl'

alias -g withcolors="| sed '/PASS/s//$(printf "\033[32mPASS\033[0m")/' | sed '/FAIL/s//$(printf "\033[31mFAIL\033[0m")/'"

alias zedn='/Applications/Zed\ Nightly.app/Contents/MacOS/cli'
alias r='cargo run'
alias cr='cargo run'
alias rr='cargo run --release'

alias p='pnpm'
alias pc='pnpm run build && pnpm run check && pnpm run test --run'

alias -g DLOG='RUST_LOG=debug,cranelift_codegen=error,h2=error,hyper_util=error,wasmtime=error,globset=error'

# jj aliases
# Most of that stuff is taken from here: https://x.com/dimfeld/status/1926863685487559038
# Workflow:
#   jj commit 
#   jjub
#   jj git push

# Get the closest ancestor bookmark
alias jjpb="jj log -r 'latest(heads(ancestors(@) & bookmarks()), 1)' --limit 1 --no-graph --ignore-working-copy -T bookmarks | tr -d '*'"

# jj update branch
jj-update-branch() {
  REV=${1:-@}
  if [ $# -gt 0 ]; then
    shift
  fi
  jj bookmark move $(jjpb) --to "$REV" "$@"
}

alias jjub=jj-update-branch
alias jn='jj new'
alias js='jj status'
alias jf='jj git fetch'
alias jp='jj git push'
alias jjl="jj log"
alias jjlt="jj log -r 'latest(ancestors(trunk()), 10)'"
alias jl="jj log"
##########
# FUNCTIONS
##########

mkdircd() {
  mkdir -p $1 && cd $1
}

render_dot() {
  local out="${1}.png"
  dot "${1}" \
    -Tpng \
    -Nfontname='JetBrains Mono' \
    -Nfontsize=10 \
    -Nfontcolor='#fbf1c7' \
    -Ncolor='#fbf1c7' \
    -Efontname='JetBrains Mono' \
    -Efontcolor='#fbf1c7' \
    -Efontsize=10 \
    -Ecolor='#fbf1c7' \
    -Gbgcolor='#1d2021' > ${out} && \
    kitty +kitten icat --align=left ${out}
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

# Open PR on GitHub
pr() {
  if type gh &> /dev/null; then
    gh pr view -w
  else
    echo "gh is not installed"
  fi
}

#########
# PROMPT
#########

setopt prompt_subst

# Kinda replaced by `vcs_prompt_info` while I experiment with `jj`
git_prompt_info() {
  local dirstatus=" OK"
  local dirty="%{$fg_bold[red]%} X%{$reset_color%}"

  if [[ ! -z $(git status --porcelain 2> /dev/null | tail -n1) ]]; then
    dirstatus=$dirty
  fi

  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo " %{$fg_bold[green]%}${ref#refs/heads/}$dirstatus%{$reset_color%}"
}

jj_prompt_info() {
  local dirty="%{$fg_bold[red]%} X%{$reset_color%}"
  local clean=""
  local conflicts="%{$fg_bold[yellow]%} !%{$reset_color%}"
  
  # Get bookmark and change info
  local bookmark=$(jj log -r @ --no-graph -T 'bookmarks' 2> /dev/null | tr -d '*' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
  local change_id=$(jj log -r @ --no-graph -T 'change_id.shortest()' 2> /dev/null) || return
  
  # Check working copy status
  local wc_status=""
  if jj status | grep -q "Working copy changes:"; then
    wc_status=$dirty
  elif jj log -r @ --no-graph -T 'conflict' 2> /dev/null | grep -q "true"; then
    wc_status=$conflicts
  else
    wc_status=$clean
  fi
  
  # Show bookmark if exists, otherwise change ID
  local ref_display="${bookmark:-$change_id}"
  echo " %{$fg_bold[green]%}${ref_display}${wc_status}%{$reset_color%}"
}

vcs_prompt_info() {
  local dirty="%{$fg_bold[red]%} X%{$reset_color%}"
  local clean=""

  # Check if we're in a jj repo
  if command -v jj &>/dev/null && jj status &>/dev/null; then
    jj_prompt_info
    return
  fi

  # Fallback to Git
  local dirstatus="$clean"
  if [[ ! -z $(git status --porcelain 2> /dev/null | tail -n1) ]]; then
    dirstatus=$dirty
  fi

  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo " %{$fg_bold[green]%}${ref#refs/heads/}$dirstatus%{$reset_color%}"
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
local promptnormal="φ %{$reset_color%}"
local promptjobs="%{$fg_bold[red]%}φ %{$reset_color%}"

# Show how many nested `nix shell`s we are in
# local nix_prompt=""
# # Set ORIG_SHLVL only if it wasn't previously set and if SHLVL > 1 and
# # GHOSTTY_RESOURCES_DIR is not empty
# if [[ -z $ORIG_SHLVL ]]; then
#   if [[ -z $GHOSTTY_RESOURCES_DIR ]]; then
#     export ORIG_SHLVL=$SHLVL
#   elif  [[ $SHLVL -gt 1 ]]; then
#     export ORIG_SHLVL=$SHLVL
#   fi
# fi;
# # If ORIG_SHLVL is set and SHLVL is now greater: display nesting level
# if [[ ! -z $ORIG_SHLVL && $SHLVL -gt $ORIG_SHLVL ]]; then
#   nix_prompt=("(%F{yellow}$(($SHLVL - $ORIG_SHLVL))%f) ")
# fi;

# PROMPT='${dir_info}$(git_prompt_info) ${nix_prompt}%(1j.$promptjobs.$promptnormal)'
PROMPT='${dir_info}$(vcs_prompt_info) ${nix_prompt}%(1j.$promptjobs.$promptnormal)'

simple_prompt() {
  local prompt_color="%B"
  export PROMPT="%{$prompt_color%}$promptnormal"
}

########
# ENV
########

export COLOR_PROFILE="dark"

case $OSTYPE in
  linux*)
    local envfile="${HOME}/.zsh.d/env.Linux.sh"
    [[ -e ${envfile} ]] && source ${envfile}
  ;;
  darwin*)
    local envfile="${HOME}/.zsh.d/env.Darwin.sh"
    [[ -e ${envfile} ]] && source ${envfile}
  ;;
esac

export LSCOLORS="Gxfxcxdxbxegedabagacad"

# Reduce delay for key combinations in order to change to vi mode faster
# See: http://www.johnhawthorn.com/2012/09/vi-escape-delays/
# Set it to 10ms
export KEYTIMEOUT=1

export PATH="$HOME/neovim/bin:$PATH"

if type nvim &> /dev/null; then
  alias vim="nvim"
  export EDITOR="nvim"
  export PSQL_EDITOR="nvim -c"set filetype=sql""
  export GIT_EDITOR="nvim"
else
  export EDITOR='vim'
  export PSQL_EDITOR='vim -c"set filetype=sql"'
  export GIT_EDITOR='vim'
fi

if [[ -e "$HOME/code/clones/lua-language-server/3rd/luamake/luamake" ]]; then
  alias luamake="$HOME/code/clones/lua-language-server/3rd/luamake/luamake"
fi


# rustup
export PATH="$HOME/.cargo/bin:$PATH"

# homebrew
export PATH="/usr/local/bin:$PATH"
export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"

# direnv
if type direnv &> /dev/null; then
  eval "$(direnv hook zsh)"
fi

# mise
# if type mise &> /dev/null; then
#   eval "$(mise activate zsh)"
# fi

# node.js
export NODE_PATH="/usr/local/lib/node_modules:$NODE_PATH"

# golang
export GOPATH="$HOME/code/go"
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:$PATH"

# fzf
if type fzf &> /dev/null && type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*" --glob "!vendor/*"'
  export FZF_CTRL_T_COMMAND='rg --files --hidden --follow --glob "!.git/*" --glob "!vendor/*"'
  export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# Try out atuin
if type atuin &> /dev/null; then
  eval "$(atuin init zsh)"
fi

# `z`
if [ -e /usr/local/etc/profile.d/z.sh ]; then
  source /usr/local/etc/profile.d/z.sh
fi

if [ -e /opt/homebrew/etc/profile.d/z.sh ]; then
  source /opt/homebrew/etc/profile.d/z.sh
fi

if [ -e "$HOME/.zsh.d/mkbir.zsh" ]; then
  source "$HOME/.zsh.d/mkbir.zsh"
fi

# yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Export my personal ~/bin as last one to have highest precedence
export PATH="$HOME/bin:$PATH"

alias c35="llm -m claude-3.5-sonnet"

# Added by Windsurf
# export PATH="/Users/thorstenball/.codeium/windsurf/bin:$PATH"

. "$HOME/.local/bin/env"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/mrnugget/bin/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/mrnugget/bin/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/mrnugget/bin/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/mrnugget/bin/google-cloud-sdk/completion.zsh.inc'; fi

export FOO2=".zshrc"


# pnpm
export PNPM_HOME="/Users/mrnugget/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
