DOTFILE_PATH := $(shell pwd)

$(HOME)/.%: %
	ln -sf $(DOTFILE_PATH)/$^ $@

irb: $(HOME)/.irbrc
ack: $(HOME)/.ackrc
git: $(HOME)/.gitconfig $(HOME)/.githelpers $(HOME)/.gitignore
psql: $(HOME)/.psqlrc
zsh: $(HOME)/.zprofile

all: irb ack git psql zsh
