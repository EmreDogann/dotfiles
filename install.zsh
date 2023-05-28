#!/usr/bin/zsh

# TODO: First draft of install script

# Create .zshenv that sources the main one in the .dotfiles/zsh directory
printf '%s\n' 'export ZDOTDIR="$HOME/.dotfiles/zsh"' 'source -- "$ZDOTDIR/.zshenv"' > $HOME/.zshenv
