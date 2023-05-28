# ----- Options Configuration -----
# Do not store duplications
setopt hist_ignore_all_dups
# Removes blank lines from history
setopt hist_reduce_blanks
# Share history across multiple zsh sessions
setopt share_history
# Append to history
setopt append_history
# Adds commands as they are typed, not at shell exit
setopt inc_append_history
# Command auto-correct suggestions
setopt correct
setopt correct_all

# Load Vim config
export MYVIMDIR="$XDG_CONFIG_HOME/vim"
export MYVIMRC="$MYVIMDIR/.vimrc"

# Set up the prompt
autoload -Uz promptinit
promptinit
prompt adam1

# Custom Prompt
export PROMPT="%m"

# External Files
source $ZDOTDIR/aliases.zsh

# fzf Options
# Use fd package if available
if command -v fd >/dev/null 2>&1; then
	export FZF_DEFAULT_COMMAND="fd --strip-cwd-prefix --hidden --follow --exclude .git"
	export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

	export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"

	# Use ~~ as the trigger sequence instead of the default **
	# export FZF_COMPLETION_TRIGGER='~~'

	# Options to fzf command
	export FZF_COMPLETION_OPTS='--border --info=inline'

	# Use fd (https://github.com/sharkdp/fd) instead of the default find
	# command for listing path candidates.
	# - The first argument to the function ($1) is the base path to start traversal
	# - See the source code (completion.{bash,zsh}) for the details.
	_fzf_compgen_path() {
	  fd --hidden --follow --exclude ".git" . "$1"
	}

	# Use fd to generate the list for directory completion
	_fzf_compgen_dir() {
	  fd --type d --hidden --follow --exclude ".git" . "$1"
	}

	# Advanced customization of fzf options via _fzf_comprun function
	# - The first argument to the function is the name of the command.
	# - You should make sure to pass the rest of the arguments to fzf.
	_fzf_comprun() {
	  local command=$1
	  shift

	  case "$command" in
		cd)           fzf --preview 'tree -C {} | head -200'   "$@" ;;
		export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
		ssh)          fzf --preview 'dig {}'                   "$@" ;;
		*)            fzf "$@"										;;
	  esac
	}
fi
# Print tree structure in the preview winodw
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --info=inline --header="<Find File> | Use CTRL-C or ESC to cancel"'
export FZF_CTRL_T_OPTS='--header="<Paste File/Directory> | Use CTRL-C to cancel"'
export FZF_ALT_C_OPTS='--header="<cd into Directory> | Use CTRL-C to cancel" --preview "tree -C {} | head -200" --info=inline'
export FZF_CTRL_R_OPTS='--header="<Paste History> | Use CTRL-C to cancel"'

# Use modern completion system
autoload -Uz compinit && compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
# zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose false

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
