#!/bin/sh

# Useful options
setopt autocd menucomplete

# Path to Oh my zsh instaltion
export ZSH="$HOME/.oh-my-zsh"

# The theme is set to random with a list of themes that it can pick from
ZSH_THEME="random"
ZSH_THEME_RANDOM_CANDIDATES=("jonathan" "bira" "mlh" "af-magic")

# Auto-correction
#ENABLE_CORRECTION="true"

# Plugins
plugins=(git themes zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# --- TheFuck --- #
eval $(thefuck --alias)
eval $(thefuck --alias fk)

# Sources
source $HOME/Work/Code/Git/dotfiles/zsh/fzf.sh
source $HOME/Work/Code/Git/dotfiles/zsh/alias.sh
