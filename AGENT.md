# Agent Instructions for dotfiles repository

## Build/Install Commands
- `make all` - Install all dotfiles as symlinks in home directory
- `make zsh` - Install just ZSH configuration
- `make git` - Install just Git configuration
- `make kitty` - Install Kitty terminal configuration
- `brew bundle --file=~/.dotfiles/Brewfile` - Install Homebrew packages

## Code Style Guidelines
- **Shell Scripts**: Use bash/zsh conventions with proper quoting
- **Configuration Files**: Follow existing indentation and formatting patterns
- **Aliases**: Group related aliases together, use short meaningful names
- **Functions**: Document complex functions with comments above definition
- **Environment Variables**: Export variables in appropriate env files (env.Darwin.sh/env.Linux.sh)

## File Organization
- ZSH config split into logical sections: history, completion, key bindings, aliases, functions, prompt, env
- OS-specific configs in separate files (aliases.Darwin.sh, env.Darwin.sh, etc.)
- Private configurations in ~/.zsh.d/private.sh (not in repo)
- Terminal configs separate for each terminal (kitty.conf, wezterm.lua, etc.)

## Testing
- Test shell configurations by sourcing: `source ~/.zshrc`
- Test symlinks by running `make all` and checking file links
- Verify OS-specific configs on both Darwin and Linux systems