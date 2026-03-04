#!/bin/sh

# # Zgen
# source "${HOME}/.zgen/zgen.zsh"
# # if the init script doesn't exist
# if ! zgen saved; then
#
#   # specify plugins here
#   zgen oh-my-zsh
#
#   # generate the init script from plugins above
#   zgen save
# fi
#
# zgen oh-my-zsh
# zgen oh-my-zsh plugins/git
# zgen oh-my-zsh plugins/themes
# zgen oh-my-zsh plugins/zsh-autosuggestions
# zgen oh-my-zsh plugins/zsh-syntax-highlighting
# zgen load davidparsson/zsh-pyenv-lazy

# Useful options
setopt autocd menucomplete

# Path to Oh my zsh instaltion
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="bira"

# Plugins
plugins=(git themes zsh-autosuggestions zsh-syntax-highlighting)

# Oh-My-Zsh source
source $ZSH/oh-my-zsh.sh

# Sources
source $HOME/.config/zsh/fzf.sh
source $HOME/.config/zsh/alias.sh

# Exports
export PATH=$PATH:/$HOME/Apps

