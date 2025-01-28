if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_vi_key_bindings --no-erase insert
    bind -M insert \e\[91\;5u 'if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char repaint-mode; end'
end

function fish_mode_prompt; end

set __fish_git_prompt_show_informative_status 1
set __fish_git_prompt_showcolorhints 1
set __fish_git_prompt_char_dirtystate 'X'
set __fish_git_prompt_char_cleanstate 'OK'
set __fish_git_prompt_char_stagedstate '+'
set __fish_git_prompt_showdirtystate 1
set __fish_git_prompt_char_stateseparator ' '
set __fish_git_prompt_color_branch green
set __fish_git_prompt_color_cleanstate green
set __fish_git_prompt_color_dirtystate red

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
