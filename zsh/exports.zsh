# Ensure path only contains unique values.
typeset -U path PATH

path+=("$HOME/.local/bin")
if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
  path+=("/mnt/c/Windows/System32")
fi
export PATH

# extra zsh completions
# fpath=($ZDOTDIR/plugins/zsh-completions/src $fpath)

# Load Vim config
export MYVIMDIR="$XDG_CONFIG_HOME/vim"
export MYVIMRC="$MYVIMDIR/.vimrc"
export VIMINIT='source $MYVIMRC'

# export COLORTERM=truecolor
