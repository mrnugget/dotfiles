if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_vi_key_bindings --no-erase insert
end

function fish_mode_prompt; end
function fish_prompt
    # Directory info with bold color
    set_color --bold
    printf '%s' (prompt_pwd)
    set_color normal

    # Git status
    if command -q git
        and test -d (git rev-parse --git-dir 2>/dev/null)
        set -l ref (git symbolic-ref HEAD 2>/dev/null)
        or set -l ref (git rev-parse --short HEAD 2>/dev/null)
        if test -n "$ref"
            printf ' %s%s' (set_color green) (string replace 'refs/heads/' '' $ref)

            # Check if dirty
            if test -n "(git status --porcelain 2>/dev/null)"
                printf '%s X' (set_color red)
            else
                printf ' OK'
            end
            set_color normal
        end
    end

    # Prompt character (φ) - red if there are background jobs, normal otherwise
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
