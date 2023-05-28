# Ensure path only contains unique values.
typeset -U path PATH

path+=("$HOME/.local/bin")
export PATH

# extra zsh completions
# fpath=($ZDOTDIR/plugins/zsh-completions/src $fpath)

# Load Vim config
export MYVIMDIR="$XDG_CONFIG_HOME/vim"
export MYVIMRC="$MYVIMDIR/.vimrc"
export VIMINIT='source $MYVIMRC'

# ----- Windows (WSL) -----
# export PATH="$PATH:/mnt/c/Users/lesmo/AppData/Local/Microsoft/WindowsApps"
# export PATH="$PATH:/mnt/c/WINDOWS"
