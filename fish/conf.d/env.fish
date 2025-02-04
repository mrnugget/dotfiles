if status is-login
    fish_add_path $HOME/bin
    fish_add_path $HOME/.cargo/bin
    fish_add_path /usr/local/bin

    set -gx GOPATH $HOME/code/go
    set -gx GOBIN $GOPATH/bin
    fish_add_path $GOBIN

    if test -x /opt/homebrew/bin/brew
        eval (/opt/homebrew/bin/brew shellenv)
    end

    if command -q nvim
        alias vim='nvim'
        set -gx EDITOR 'nvim'
    else
        set -gx EDITOR 'vim'
    end

    set -gx VISUAL $EDITOR
    set -gx GIT_EDITOR $EDITOR

    test -f "$HOME/.orbstack/shell/init.fish"; and source "$HOME/.orbstack/shell/init.fish"

    test -f "$HOME/.local/bin/env.fish"; and  source "$HOME/.local/bin/env.fish"

    test -f "$HOME/.codeium/windsurf/bin"; and fish_add_path "$HOME/.codeium/windsurf/bin"

    test -f "$HOME/google-cloud-sdk/path.fish.inc"; and source "$HOME/google-cloud-sdk/path.fish.inc"

    if type -q direnv
        direnv hook fish | source
    end

    if type -q mise
        mise activate fish | source
    end

    if type -q atuin
        atuin init fish | source
    end

    if type -q zoxide
        zoxide init fish | source
    end
end
