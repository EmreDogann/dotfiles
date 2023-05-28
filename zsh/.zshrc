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
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

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
