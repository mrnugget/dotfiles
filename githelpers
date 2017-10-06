#!/bin/bash

HASH="%C(always,yellow)%h%C(always,reset)"
RELATIVE_TIME="%C(always,green)%ar%C(always,reset)"
AUTHOR="%C(always,bold blue)%an%C(always,reset)"
REFS="%C(always,red)%d%C(always,reset)"
SUBJECT="%s"

FORMAT="$HASH $RELATIVE_TIME{$AUTHOR{$REFS $SUBJECT"

pretty_git_log() {
  git log --graph --pretty="tformat:$FORMAT" $* |
  column -t -s '{' |
  less -XRS --quit-if-one-screen
}

remove_untracked_files() {
  git ls-files --other --exclude-standard | xargs rm -rf
}
