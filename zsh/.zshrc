# ----- Options Configuration -----
setopt hist_ignore_all_dups hist_reduce_blanks share_history append_history inc_append_history
setopt correct correct_all
setopt menu_complete nomatch
setopt interactive_comments

# Disable ctrl-s to freeze terminal
stty stop undef

# Switch to emacs mode
bindkey -e

# Source file if it exists.
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh	# fzf fuzzy search

[ -f "$ZDOTDIR/prompt.zsh" ] && source "$ZDOTDIR/prompt.zsh"
[ -f "$ZDOTDIR/exports.zsh" ] && source "$ZDOTDIR/exports.zsh"
[ -f "$ZDOTDIR/theme.zsh" ] && source "$ZDOTDIR/theme.zsh"
[ -f "$ZDOTDIR/aliases.zsh" ] && source "$ZDOTDIR/aliases.zsh"

# Use fd package if available
if command -v fd >/dev/null 2>&1
then
	export FZF_DEFAULT_COMMAND="fd --strip-cwd-prefix --hidden --follow --exclude .git"
	export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
	export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"

	# - The first argument to the function ($1) is the base path to start traversal
	_fzf_compgen_path() {
	  fd --hidden --follow --exclude ".git" . "$1"
	}

	# Use fd to generate the list for directory completion
	_fzf_compgen_dir() {
	  fd --type d --hidden --follow --exclude ".git" . "$1"
	}

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

# Use ~~ as the trigger sequence instead of the default **
# export FZF_COMPLETION_TRIGGER='~~'

export FZF_COMPLETION_OPTS='--border --info=inline'
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --height 40% --layout=reverse --border --info=inline --header='<Find File> | Use CTRL-C or ESC to cancel'"
export FZF_CTRL_T_OPTS='--header="<Paste File/Directory Path> | Use CTRL-C or ESC to cancel"'
export FZF_ALT_C_OPTS='--header="<cd into Directory> | Use CTRL-C or ESC to cancel" --preview "tree -C {} | head -200" --info=inline'
export FZF_CTRL_R_OPTS='--header="<Paste History> | Use CTRL-C or ESC to cancel"'

# Use modern completion system
autoload -Uz compinit && compinit
zmodload zsh/complist

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*' completer _expand_alias _expand _complete _correct _approximate
zstyle ':completion:*' group-name ''
# zstyle ':completion:*' menu select
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' verbose true
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# complete manual by their section
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.*' insert-sections   true
zstyle ':completion:*:man:*' menu yes select


# Syntax highlighting theme
source $ZDOTDIR/colors/catppuccin/zsh-syntax-highlighting/themes/catppuccin_$THEMEVARIANT-zsh-syntax-highlighting.zsh

# Auto suggestions
source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Zsh syntax highlighting
source $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

