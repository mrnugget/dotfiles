DOTFILE_PATH := $(shell pwd)

$(HOME)/.%: %
	ln -sf $(DOTFILE_PATH)/$^ $@

irb: $(HOME)/.irbrc
ack: $(HOME)/.ackrc
git: $(HOME)/.gitconfig $(HOME)/.githelpers $(HOME)/.gitignore
psql: $(HOME)/.psqlrc
zsh: $(HOME)/.zshrc $(HOME)/.zsh.d
tmux: $(HOME)/.tmux.conf

$(HOME)/.config/kitty/kitty.conf:
	mkdir -p $(HOME)/.config/kitty
	ln -sf $(DOTFILE_PATH)/kitty.conf $(HOME)/.config/kitty/kitty.conf
kitty: $(HOME)/.config/kitty/kitty.conf

all: irb ack git psql zsh tmux kitty
