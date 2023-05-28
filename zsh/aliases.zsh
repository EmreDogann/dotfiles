# Options Configuration
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_minus
setopt pushd_silent
DIRSTACKSIZE=8

# ----- Git -----
alias gs='git status'
alias ga='git add'
alias gp='git push'
alias gpo='git push origin'
alias gtd='git tag --delete'
alias gtdr='git tag --delete origin'
alias gr='git branch -r'
alias gplo='git pull origin'
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'
alias gco='git checkout'
alias gl='git log'
alias gr='git remote'
alias grs='git remote show'
alias glo='git log --pretty="oneline"'
alias glol='git log --graph --oneline --decorate'

# ----- Directories -----
# Auto_cd required for this to work.
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
# Enables going back to previous directory
alias -- -='cd -'

# Will list the directories on the stack from 1-9.
alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index

# List directory contents
alias lsa='ls -lah'
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'

# ----- Other -----
alias reload="source $ZDOTDIR/.zshrc && echo 'ZSH config reloaded from $ZDOTDIR/.zshrc'"
alias zshdr="cd $ZDOTDIR"
alias zshrc="vim $ZDOTDIR/.zshrc"
alias zshev="vim $HOME/.zshenv"
alias zshal="vim $ZDOTDIR/aliases.zsh"
alias vimdr="cd $MYVIMDIR"
alias vimrc="vim $MYVIMRC"

# ----- Functions -----
if command -v fzf > /dev/null; then
	vif() {
		local fname
		fname=$(fzf) || return
		vim "$fname"
	}

	fcd() {
		local dirname
		dirname=$(find -type d | fzf) || return
		cd "$dirname"
	}
fi
