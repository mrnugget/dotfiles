UNAME := $(shell uname)
DOTFILE_PATH := $(shell pwd)

$(HOME)/.%: %
	ln -sf $(DOTFILE_PATH)/$^ $@

irb: $(HOME)/.irbrc
ack: $(HOME)/.ackrc
git: $(HOME)/.gitconfig $(HOME)/.githelpers $(HOME)/.gitignore
psql: $(HOME)/.psqlrc
zsh: $(HOME)/.zshrc $(HOME)/.zsh.d
tmux: $(HOME)/.tmux.conf
	mkdir -p $(HOME)/bin
	ln -sf $(DOTFILE_PATH)/bin/tmux-sessionizer $(HOME)/bin/tmux-sessionizer
	chmod +x $(HOME)/bin/tmux-sessionizer

kitty:
	mkdir -p $(HOME)/.config/kitty
	ln -sf $(DOTFILE_PATH)/kitty.conf $(HOME)/.config/kitty/kitty.conf
	ln -sf $(DOTFILE_PATH)/kitty_colors_lucius_light_high_contrast.conf $(HOME)/.config/kitty/theme.conf
ifeq ($(UNAME), Linux)
	ln -sf $(DOTFILE_PATH)/kitty.linux.conf $(HOME)/.config/kitty/kitty.linux.conf
endif

imwheel: $(HOME)/.imwheelrc

all: irb ack git psql zsh tmux kitty imwheel
