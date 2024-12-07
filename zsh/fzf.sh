# --- FZF --- #

# Set up for fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

# Use fd instead of fzf
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd for listing path candidates
_fzf_compgen_path() {
	fd --hidden --exclude .git ."$1"
}

# Use fd to genereate the lise for directory completion when using **
_fzf_compgen_dir() {
	fd --type=d --hidden --exclude .git . "$1"
}

source ~/Work/Code/Git/fzf-git.sh/fzf-git.sh

export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--previe 'eza --tree --color=always {} | head -200'"

# Genereates preview using eza and bat when using the ** method
_fzf_comprun() {
	local command=$1
	shift

	case "$command" in
		cd)				fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
		export|unset)	fzf --preview "eval 'echo \$' {}" "$@" ;;
		ssh)			fzf --preview 'dig {}' "$@" ;;
		*)				fzf --preview 'bat -n --color=always --line-range :500 {}' "$@" ;;
	esac
}
