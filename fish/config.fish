if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_vi_key_bindings --no-erase insert
end

function fish_mode_prompt; end

set __fish_git_prompt_show_informative_status 1
set __fish_git_prompt_showcolorhints 1
# # set __fish_git_prompt_char_dirtystate 'X'
# # set __fish_git_prompt_char_cleanstate 'OK'
set __fish_git_prompt_char_stagedstate '+'
# set __fish_git_prompt_showdirtystate 1
set __fish_git_prompt_char_stateseparator ' '
# set __fish_git_prompt_color_branch green
# set __fish_git_prompt_color_cleanstate green
# set __fish_git_prompt_color_dirtystate red

function fish_prompt
    set_color --bold
    printf '%s' (prompt_pwd)
    set_color normal

    fish_git_prompt " %s"

    if jobs -q
        set_color --bold red
        printf ' φ '
    else
        set_color normal
        printf ' φ '
    end
    set_color normal
end

set fish_greeting

theme_gruvbox dark hard

alias lls='ls -lh --sort=size --reverse'
alias llt='ls -lrt'
alias hs='history | grep'
alias rsyncssh='rsync -Pr --rsh=ssh'

alias gst='git status'
alias s='git status'
alias gaa='git add -A'
alias gc='git commit'
alias gcm='git checkout main'
alias gd='git diff'
alias gdc='git diff --cached'
alias co='git checkout'
alias up='git push'
alias upf='git push --force'
alias pu='git pull'
alias pur='git pull --rebase'
alias fe='git fetch'
alias re='git rebase'
alias lr='git l -30'
alias cdr='cd (git rev-parse --show-toplevel)' # cd to git Root
alias hs='git rev-parse --short HEAD'
alias hm='git log --format=%B -n 1 HEAD'

alias tma='tmux attach -t'
alias tmn='tmux new -s'
alias tmm='tmux new -s main'

alias got='go test ./...'
alias k='kubectl'
alias r='cargo run'
alias cr='cargo run'
alias rr='cargo run --release'

# Functions
function mkdircd
    mkdir -p $argv[1] && cd $argv[1]
end

function render_dot
    set out "$argv[1].png"
    dot "$argv[1]" \
        -Tpng \
        -Nfontname='JetBrains Mono' \
        -Nfontsize=10 \
        -Nfontcolor='#fbf1c7' \
        -Ncolor='#fbf1c7' \
        -Efontname='JetBrains Mono' \
        -Efontcolor='#fbf1c7' \
        -Efontsize=10 \
        -Ecolor='#fbf1c7' \
        -Gbgcolor='#1d2021' > $out
    and kitty +kitten icat --align=left $out
end

function serve
    set port $argv[1]
    if test -z "$port"
        set port 8000
    end
    set ip (ipconfig getifaddr en0)
    echo "Serving on $ip:$port ..."
    python -m SimpleHTTPServer $port
end

set -gx EDITOR (command -v nvim || echo "vim")
set -gx VISUAL $EDITOR
set -gx GIT_EDITOR $EDITOR

fish_add_path $HOME/bin
fish_add_path $HOME/.cargo/bin
fish_add_path /usr/local/bin

set -gx GOPATH $HOME/code/go
set -gx GOBIN $GOPATH/bin
fish_add_path $GOBIN

if type -q direnv
    direnv hook fish | source
end

if type -q mise
    mise activate fish | source
end

if type -q atuin
    atuin init fish | source
end
