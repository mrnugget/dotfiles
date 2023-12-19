# dotfiles

This includes my configuration for homebrew, ZSH, git, terminal emulators and other stuff.

## Requirements

* git
* make

## Install

To set up all of the files as symlinks in your home directory, just run this:

```
make all
```

## Installing with homebrew

```
brew bundle --file=~/.dotfiles/Brewfile
```

and

```
brew bundle --force cleanup --file=~/.dotfiles/Brewfile
```
