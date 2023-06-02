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
alias reload="exec zsh"
alias zshdr="cd $ZDOTDIR"
alias zshrc="vim $ZDOTDIR/.zshrc"
alias zshev="vim $ZDOTDIR/.zshenv"
alias zshal="vim $ZDOTDIR/aliases.zsh"
alias vimdr="cd $MYVIMDIR"

function vimrc() {
	if [[ -f "$MYVIMDIR/sessions/vimrc_session.vim" ]] then
		vim -S "$MYVIMDIR/sessions/vimrc_session.vim" $MYVIMRC
	else
		vim $MYVIMRC
	fi
}

# Replace cat with bat 
alias cat='bat --paging=never'

case "$(uname -s)" in

	Darwin)
		# echo 'Mac OS X'
	;;

	Linux)
		alias ls='ls --color=auto'
	;;

	CYGWIN*|MINGW32*|MSYS*|MINGW*)
		echo 'zsh/aliases.zsh: MS Windows'
	;;
esac

# ----- Searching -----
if command -v fzf > /dev/null; then
	alias vimf="fzf --bind 'enter:become(vim {})'"
	alias cdf="fd --type d --strip-cwd-prefix --hidden --follow --exclude .git | fzf --print0 | xargs --no-run-if-empty -0 -o cd"
fi
