# dotfiles

This includes my configuration for ZSH, git, psql, irb, tmux and others.

### Requirements

* git
* make

### Install

To set up all of the files as symlinks in your home directory, just run this:

```
make all
```

## ZSH

ZSH is set up to have full completion for killing processes, `cd`-ing to a
directory, `ssh`-ing to known hosts and other stuff.

### Keybindings

The Vim keybindings are activated by default. Plus some non-Vim keybindings:

* `Ctrl-R` to search back in ZSH history incrementally.
* `Ctrl-S` to search forward in ZSH history incrementally.
* `Ctrl-Y` to accept a search result.
* `Ctrl-P` to go back in history.
* `Ctrl-N` to go forward in history.
* `Ctrl-A` to go to the beginning of the line.
* `Ctrl-E` to go to the end of the line.
* `Ctrl-Q` to push the current line onto the stack to run a new command.

### Aliases

Some aliases that are set up:

* `hs` - Search through ZSH history.
* `tma` - Attach to a running a tmux session.
* `tmn` - Create a new tmux session.
* `fazz` - Use `fzz` with `ag`.
* `fizz` - Use `fzz` with `find`.

There are also shortcuts for the most commonly used git subcommands and other
stuff.

Aliases that only work on Linux, or only work on OS X, are in
`zsh.d/aliases.Linux.sh` and `zsh.d/aliases.Darwin.sh` respectively and sourced
automatically.

### Functions
Some functions defined in `zshrc`:

* `mkdircd` - Create a directory and `cd` into it.
* `serve` - Serve the current directory with Python's SimpleHTTPServer.
* `gifs3` - Push a gif to S3 and copy the resulting URL to the clipboard.
* `vimfzz` - Run `fzz` with `ag` and open the results in Vim.
* `cdzz` - Find files with `fzz` and `find`, then `cd` into the first resulting
  directory.

### Prompt

The ZSH prompt shows the current directory, the current git branch, whether the git
branch is dirty or not. 

The prompt also shows whether a background job is running in the current session
or not. Here it is without a background job and a dirty directory:

![Prompt with dirty directory and no background job.](http://s3.thorstenball.com/gif/prompt_dirty_no_background_job.png)

Here is the prompt after Vim has been suspended with Ctrl-Z:

![Prompt with dirty directory and a background job.](http://s3.thorstenball.com/gif/prompt_dirty_background_job.png)

### Environment

Vim is set up as the default editor in `psql` with `PSQL_EDITOR`, so
it starts when `\e` is used in `psql`.

The delay for key combinations is redureced with `KEYTIMEOUT`. `EDITOR` is, of
course, Vim.

Go is also set up. As is the `PATH`.

Platform-dependent environment variables are set up in `zsh.d/env.Linux.sh` and
`zsh.d/env.Darwin.sh`.
