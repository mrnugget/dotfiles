fish_add_path $HOME/bin
fish_add_path $HOME/.cargo/bin
fish_add_path /usr/local/bin

set -gx GOPATH $HOME/code/go
set -gx GOBIN $GOPATH/bin
fish_add_path $GOBIN

if test -x /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
end


test -f ~/.orbstack/shell/init.fish; and source ~/.orbstack/shell/init.fish

test -f "$HOME/.local/bin/env.fish"; and  source "$HOME/.local/bin/env.fish"

if type -q direnv
    direnv hook fish | source
end

if type -q mise
    mise activate fish | source
end

if type -q atuin
    atuin init fish | source
end
