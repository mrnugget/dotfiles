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

kitty:
	mkdir -p $(HOME)/.config/kitty
	ln -sf $(DOTFILE_PATH)/kitty.conf $(HOME)/.config/kitty/kitty.conf
	ln -sf $(DOTFILE_PATH)/kitty_colors.conf $(HOME)/.config/kitty/kitty_colors.conf
	ln -sf $(DOTFILE_PATH)/kitty_colors_lucius_light_high_contrast.conf $(HOME)/.config/kitty/kitty_colors_lucius_light_high_contrast.conf
	ln -sf $(HOME)/.config/kitty/kitty_colors_lucius_light_high_contrast.conf $(HOME)/.config/kitty/theme.conf
ifeq ($(UNAME), Linux)
	ln -sf $(DOTFILE_PATH)/kitty.linux.conf $(HOME)/.config/kitty/kitty.linux.conf
endif


all: irb ack git psql zsh tmux kitty
