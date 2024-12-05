### Sets ###
set fish_greeting
set PATH $PATH $HOME/Apps
set -x PATH $HOME/.pyenv/bin $PATH

### Aliases ###
alias ..="cd .."
alias nv="nvim"
alias pacman="sudo pacman"
alias update="sudo pacman -Syu"
alias msfc="/usr/bin/msfconsole"
# more to be added

### Start x ###
if status --is-interactive
	if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
		exec startx
	end
end

### Needed for pyenv ###
pyenv init - | source
status --is-interactive; and pyenv virtualenv-init - | source
