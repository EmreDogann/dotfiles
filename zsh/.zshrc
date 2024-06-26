# ----- Options Configuration -----
setopt hist_ignore_all_dups hist_reduce_blanks share_history append_history inc_append_history
# setopt correct correct_all
setopt menu_complete nomatch
setopt interactive_comments

# Disable ctrl-s to freeze terminal
stty stop undef

# Switch to emacs mode
# bindkey -e
# bindkey '^[[1;5C' emacs-forward-word
# bindkey '^[[1;5D' emacs-backward-word

# Better vi mode
# Do the initialization when the script is sourced (i.e. Initialize instantly)
# ZVM_INIT_MODE=sourcing
[ -f "$ZDOTDIR/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh" ] && source "$ZDOTDIR/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
# The plugin will auto execute this zvm_after_init function
function zvm_after_init() {
	[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
	autoload -Uz compinit && compinit
	zmodload zsh/complist
}
ZVM_ESCAPE_KEYTIMEOUT=0.01

# Source file if it exists.
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
	  fd --no-ignore --hidden --follow --exclude ".git" . "$1"
	}

	# Use fd to generate the list for directory completion
	_fzf_compgen_dir() {
	  fd --type d --no-ignore --hidden --follow --exclude ".git" . "$1"
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
		*)            fzf --preview 'bat -n --color=always {}' "$@"	;;
	  esac
	}
fi

# Use ~~ as the trigger sequence instead of the default **
# export FZF_COMPLETION_TRIGGER='~~'
export FZF_COMPLETION_OPTS='--border --info=inline'
export FZF_HEADER_MSG='| Use CTRL-C or ESC to cancel'
printf -v fzfPreviewControls '%s' \
	"--bind 'ctrl-y:preview-up,ctrl-e:preview-down,"\
	"ctrl-b:preview-page-up,ctrl-f:preview-page-down,"\
	"ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down'"
	# "shift-up:preview-top,shift-down:preview-bottom,"\
	# "alt-up:half-page-up,alt-down:half-page-down,"\
# export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --preview 'bat --style=numbers --line-range :300  --color=always {}' --multi --height 40% --layout=reverse --border --info=inline --header='<Find File> $FZF_HEADER_MSG' $fzfPreviewControls"
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --preview 'bat --style=numbers --line-range :300  --color=always {}' --multi --height 40% --layout=reverse --border --info=inline --header='<Find File>'"
export FZF_CTRL_T_OPTS="--header='<Paste File/Directory Path> $FZF_HEADER_MSG'"
export FZF_ALT_C_OPTS="--header='<cd into Directory> $FZF_HEADER_MSG' --preview 'tree -C {} | head -200' --info=inline"
export FZF_CTRL_R_OPTS="--header='<Paste History> $FZF_HEADER_MSG'"

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

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
