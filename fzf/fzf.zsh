# Setup fzf
# ---------
if [[ ! "$PATH" == */home/slydog/.dotfiles/tools/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/slydog/.dotfiles/tools/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/slydog/.dotfiles/tools/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/slydog/.dotfiles/tools/fzf/shell/key-bindings.zsh"
