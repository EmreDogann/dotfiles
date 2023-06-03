#!/usr/bin/zsh

# TODO: First draft of install script
# NOTE: Only tested on Ubuntu. Might work on Debian.

# Create .zshenv that sources the main one in the .dotfiles/zsh directory
printf '%s\n' 'export ZDOTDIR="$HOME/.dotfiles/zsh"' > $HOME/.zshenv
