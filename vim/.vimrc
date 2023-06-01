set encoding=utf-8
scriptencoding utf-8

let g:USING_WSL = has("unix") && system("uname -r") =~ "microsoft"

" Disable vi compatibility, if for some reason it's on.
if &compatible
	set nocompatible
endif

" File Paths ----------------------------------------------------------------{{{
" From -  https://github.com/z0rc/dotfiles/blob/main/vim/vimrc
" Set default 'runtimepath' without ~/.vim folders
let &runtimepath=printf('%s/vimfiles,%s,%s/vimfiles/after', $VIM, $VIMRUNTIME, $VIM)
" What is the name of the directory containing this file?
let s:portable=expand('<sfile>:p:h')
" Add the directory to 'runtimepath'
let &runtimepath=printf('%s,%s,%s/after', s:portable, &runtimepath, s:portable)
let &packpath=&runtimepath

" Set directory for swap & backup files.
" // - Ensures files created are uniquely named.
set directory=$MYVIMDIR/swap//
set viminfo='50,<1000,s100,:100,h,n$MYVIMDIR/.viminfo
set backupdir=$MYVIMDIR/backup//
set undodir=$MYVIMDIR/undo//
set spellfile=$MYVIMDIR/spell/en.utf-8.add

" }}}

" GENERAL ----------------------------------------------------------------{{{
" Enable backups
set backup

" Enable undo file
set undofile

" Enable type file detection. Vim will be able to try to detect the type of file is use.
filetype on

" Enable plugins and load plugin for the detected filec type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

" Change grepprg to use ripgrep.
if executable("rg")
	set grepprg=rg\ --vimgrep\ --smart-case\ --hidden
	set grepformat=%f:%l:%c:%mc
endif

" Types of keyword completion to look for
" kSpell - dictionary
set complete+=kspell

" Spelling language
set spelllang=en_us
set spellsuggest+=10

" Configure timeout duration.
set ttimeout
set timeoutlen=1000
set ttimeoutlen=10	" Under 10 causes cursor glitching when exiting insert mode.
set ttyfast

" Allow backspace to work over various features in insert mode.
set backspace=indent,eol,start

" Enable Mouse features/scrolling in all modes.
set mouse=a
" Fixes mouse click problems: e.g
" CLick dragging not updating until mouse up
" Mouse clicks not working on the right side of the screen
set ttymouse=sgr
map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>

" Disable moving cursor to first non-blank character in line after commands.
set nostartofline

" Add line numbers.
set number

" Change to relative line numbers.
set relativenumber

" Highlight cursor line underneath the cursor horizontally.
set cursorline

" Set shift width to "4 spaces.
set shiftwidth=4

" Set tab width to 4 columns.
set tabstop=4

" Keep indentation from previous line
set autoindent

" Automatically inserts indentation in some cases
set smartindent

" Like smartindent, but stricter and more customisable
" set cindent

" Do not let cursor scroll below or above N number of lines when scrolling.
set scrolloff=2

" Do not let cursor scroll past N number of columns when side scrolling.
set sidescroll=1
set sidescrolloff=2

" Do not wrap lines. Allow long lines to extend as far as the line goes.
set nowrap

" While searching though a file incrementally highlight matching characters as you type.
set incsearch

" Ignore capital letters during search.
set ignorecase

" Override the ignorecase option if searching for capital letters.
" This will allow you to search specifically for capital letters.
set smartcase

" Show partial command you type in the last line of the screen.
set showcmd

" Show the mode you are on the last line.
set noshowmode

" Show matching words during a search.
" set showmatch

" Use highlighting when doing a search.
set hlsearch

" Set the commands to save in history default number is 20.
set history=1000

" Enable auto completion menu after pressing TAB.
set wildmenu

" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest

" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" Session options
set ssop-=options

" Open new split panes to right and bottom, more natural than defaults.
set splitbelow
set splitright

" Status Line Options
set laststatus=2

" Must be set before clever-f is loaded
let g:clever_f_mark_char_color='CustomCleverFCharColor'

" }}}

" PLUGINS ----------------------------------------------------------------{{{

" PLUGIN LOADER AUTOMATION -----------------------------------------------{{{
let data_dir = has('nvim') ? stdpath('data') . '/site' : expand('$MYVIMDIR')
if empty(glob(data_dir . '/autoload/plug.vim'))
	silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
			\| PlugInstall --sync | source $MYVIMRC
			\| endif

" }}}

" Plug sets by default:
" 	filetype off
" 	filetype plugin indent on
" 	syntax on
call plug#begin(data_dir . '/plugged')

Plug expand($XDG_CONFIG_HOME) . '/tools/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'matze/vim-move'
Plug 'tpope/vim-surround'
Plug 'junegunn/vim-peekaboo'
Plug 'tpope/vim-commentary'
Plug 'machakann/vim-highlightedyank'
Plug 'andymass/vim-matchup'
Plug 'junegunn/vim-slash'
" Plug 'yggdroot/indentline'
Plug 'rhysd/clever-f.vim'

" ---- Theme/Colors ----
Plug 'itchyny/lightline.vim'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }

call plug#end()

" }}}

" PLUGIN SETTINGS --------------------------------------------------------{{{

" Set color scheme & settings
let g:lightline = {'colorscheme': 'catppuccin_' . $THEMEVARIANT}
set termguicolors
colorscheme catppuccin_$THEMEVARIANT

" Turn syntax highlighting on.
syntax on

" Clever-f settings
let g:clever_f_show_prompt=1
" let g:clever_f_mark_direct=1
let g:clever_f_smart_case=1
let g:clever_f_across_no_line=1
let g:clever_f_fix_key_direction=1
call functions#ExtendHighlight('Error', 'CustomCleverFCharColor', 'cterm=underline')

let g:move_key_modifier = 'S'
let g:move_key_modifier_visualmode = 'S'

let g:highlightedyank_highlight_duration = 300

" Preview window is hidden by default. You can toggle it with ctrl-/.
" It will show on the right with 50% width, but if the width is smaller
" than 70 columns, it will show above the candidate list
let g:fzf_preview_window = ['right,50%,<70(up,40%)', 'ctrl-/']
" This is the default extra key bindings
let g:fzf_action = {
			\ 'ctrl-t': 'tab split',
			\ 'ctrl-h': 'split',
			\ 'ctrl-x': 'vsplit' }	

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '$HOME/.local/share/fzf-history'

let g:fzf_tags_command = 'ctags -R'

command! -bang -nargs=? -complete=dir Files
			\ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)
command! -bang -nargs=* Rg
			\ call fzf#vim#grep("rg --line-number --no-ignore --no-heading --hidden --follow --glob='!.git/' --color=always --smart-case -- " . shellescape(<q-args>),
			\ 1, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)
command! -bang -nargs=* Projfind
			\ call fzf#vim#grep("rg --no-ignore --hidden --follow --smart-case --no-heading --line-number --color=always --glob='!.git/' -- " . shellescape(<q-args>)
			\ . ' ' . (system('git status') =~ '^fatal' ? expand("%:p:h") : system("git rev-parse --show-toplevel")), 1, fzf#vim#with_preview(), <bang>0)

command! -nargs=* -bang RG call functions#RipgrepFzf(<q-args>, <bang>0)

" }}}

" MAPPINGS ----------------------------------------------------------------{{{

" Set <space> as the leader key
let mapleader = ' '

" Remap s to something else
" :map s

" Set mark, Save file, save session, reload, print status message, jump back
" to mark (original cursor position).
noremap <silent> <C-s> :call functions#SaveAndReload()<CR>

" Yank to end of line instead of whole line.
nmap Y y$

" Paste from "0 register by default unless a register other than the default is specified.
" From: https://stackoverflow.com/questions/18391573/how-make-vim-paste-to-always-paste-from-register-0-unless-its-specified
" nnoremap <silent> p :<C-U>call functions#FormatPaste(v:register, 'p', 1)<CR>
nnoremap <silent> P :<C-U>call functions#FormatPaste(v:register, 'P', 1)<CR>
xnoremap <silent> p :<C-U>call functions#FormatPaste(v:register, 'p', 1)<CR>
xnoremap <silent> P :<C-U>call functions#FormatPaste(v:register, 'P', 1)<CR>

" Paste from default register (used for deleted text as a for of cut & paste).
nnoremap <silent> <leader>p :<C-U>call functions#FormatPaste('"', 'p')<CR>
nnoremap <silent> <leader>P :<C-U>call functions#FormatPaste('"', 'P')<CR>
xnoremap <silent> <leader>p :<C-U>call functions#FormatPaste('"', 'p')<CR>
xnoremap <silent> <leader>P :<C-U>call functions#FormatPaste('"', 'P')<CR>

" Select most recent pasted text
nnoremap <expr> gV "`[".getregtype(v:register)[0]."`]"

" Paste from system clipboard
" NOTE: vim must be compiled with clipboard support for this to work.
" If using WSL...
if g:USING_WSL
	nnoremap cp :<C-U>call functions#FixDOSLineEndings('"+p')<CR>
	nnoremap cP :<C-U>call functions#FixDOSLineEndings('"+P')<CR>
	xnoremap cp :<C-U>call functions#FixDOSLineEndings('"+p', visualmode())<CR>
	xnoremap cP :<C-U>call functions#FixDOSLineEndings('"+P', visualmode())<CR>
else
	nnoremap cp "+p
	nnoremap cP "+P
	xnoremap cp "+p
	xnoremap cP "+P
endif

" Clipboard bindings
if has("win32")
	" Windows options here
elseif has("unix")
	let s:uname = system("uname")
	if s:uname == "Darwin\n"
		" Mac options here
	else
		if g:USING_WSL && executable("clip.exe")
			nnoremap <silent> <expr> cy functions#YankFixedCursor("")
			nnoremap <silent> <expr> cyy functions#YankFixedCursor("_")
			xnoremap <silent> Y :<C-U>call functions#SendToClip(visualmode(),1)<CR>
		endif
	endif
endif

" Edit vimrc configuration file
nnoremap \ve :e $MYVIMRC<CR>
" Edit statusline configuration file
nnoremap \vs :e $MYVIMDIR/statusline.vim<CR>
" Reload vimrc configuration file
nnoremap \vr :source $MYVIMRC<CR>

" Turn off arrow keys
noremap <Up> :echoerr "nono don be stopid"<CR>
noremap <Down> :echoerr "nono don be stopid"<CR>
noremap <Left> :echoerr "nono don be stopid"<CR>
noremap <Right> :echoerr "nono don be stopid"<CR>

inoremap <Up> <C-\><C-O>:exec 'echohl ErrorMsg \| echomsg "nono don be stopid" \| echohl None'<CR>
inoremap <Down> <C-\><C-O>:exec 'echohl ErrorMsg \| echomsg "nono don be stopid" \| echohl None'<CR>
inoremap <Left> <C-\><C-O>:exec 'echohl ErrorMsg \| echomsg "nono don be stopid" \| echohl None'<CR>
inoremap <Right> <C-\><C-O>:exec 'echohl ErrorMsg \| echomsg "nono don be stopid" \| echohl None'<CR>

" Fzf file search
noremap <C-P> :Files<CR>
noremap <leader>l :BLines<CR>
noremap <leader>b :Buffers<CR>
noremap <leader>/ :Rg<CR>
" noremap <leader>/. :exec ':Rg ' . expand("%:p:h")<CR>
noremap <leader>t :Tags<CR>
noremap <leader>m :Marks<CR>
" nnoremap <silent> <Leader>g :Commits<CR>
nnoremap <silent> <Leader>? :Helptags<CR>
nnoremap <silent> <Leader>hh :History<CR>
nnoremap <silent> <Leader>h: :History:<CR>
nnoremap <silent> <Leader>h/ :History/<CR> 

imap <c-x><c-l> <plug>(fzf-complete-line)
inoremap <expr> <c-x><c-f> fzf#vim#complete#path('fd')
inoremap <expr> <c-x><c-k> fzf#vim#complete#word('cat /usr/share/dict/words', {'window': { 'width': 0.2, 'height': 0.9, 'xoffset': 1 }})

" Toggle spell check.
nnoremap <F5> :setlocal spell!<CR>
inoremap <F5> <C-o>:setlocal spell!<CR>

" Automatically fix the last misspelled word and jump back to where you were.
"   Taken from this talk: https://www.youtube.com/watch?v=lwD8G1P52Sk
nnoremap <Leader>sp :normal! mz[s1z=`z<CR>

" Insert mode completion
nnoremap \s a<C-X><C-S><C-P>

" Press * to search for the term under the cursor or a visual selection and
" then press a key below to replace all instances of it in the current file.
" The extra 'c' at the end will ask for confirmation before replacing.
nnoremap <Leader>r :%s///g<Left><Left>
" nnoremap <Leader>rc :%s///gc<Left><Left><Left>

" The same as above but instead of acting on the whole file it will be
" restricted to the previously visually selected range. You can do that by
" pressing *, visually selecting the range you want it to apply to and then
" press a key below to replace all instances of it in the current selection.
" The extra 'c' at the end will ask for confirmation before replacing.
xnoremap <Leader>r :s///g<Left><Left>
" xnoremap <Leader>rc :s///gc<Left><Left><Left>

" Type a replacement term and press . to repeat the replacement again. Useful
" for replacing few instances of the term (comparable to multiple cursors).
nnoremap <silent> <Leader>* :let @/='\<'.expand('<cword>').'\>'<CR>cgn
xnoremap <silent> <Leader>* "sy:let @/=@s<CR>cgn

" Copy line above/below
" <C-O> in insert mode - toggles in and out of insert to normal mode.
" <C-U> in normal mode will clear the extra range/info after a : is pressed,
" (:'<,'> in visual mode) just leaving the : in the command line.
" nnoremap <silent> <expr> <M-k> ":copy .-1<CR>==" . (v:count1 - 1 == 0 ? "" : (v:count1 - 1) . "k")
" nnoremap <silent> <expr> <M-j> ":copy .<CR>=="
" vnoremap <silent> <M-k>    :<C-U>exec "'<,'>copy '<-" . (1+v:count1)<CR>gv
" vnoremap <silent> <M-j>  :<C-U>exec "'<,'>copy '>+" . (0+v:count1)<CR>gv

" line text-objects
" -----------------
" il al
xnoremap          il g_o^o
onoremap <silent> il :<c-u>exe 'normal v' . v:count1 . 'il'<CR>
xnoremap          al g_o0o
onoremap <silent> al :<c-u>exe 'normal v' . v:count1 . 'al'<CR>

" Easier split navigation.
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" }}}

" VIMSCRIPT --------------------------------------------------------------{{{

" This will enable code folding.
" Use the marker method of folding.
augroup codeFolding
	autocmd!
	autocmd FileType vim setlocal foldmethod=marker
augroup END

augroup colorScheme
	autocmd!
	autocmd ColorScheme * call functions#ExtendHighlight('Error', 'CustomCleverFCharColor', 'cterm=underline')
augroup END

" Cursor settings:

"  1 -> blinking block
"  2 -> solid block 
"  3 -> blinking underscore
"  4 -> solid underscore
"  5 -> blinking vertical bar
"  6 -> solid vertical bar
let &t_SI="\e[6 q" "SI = INSERT mode
let &t_SR="\e[4 q" "SR = REPLACE mode
let &t_EI="\e[2 q" "EI = NORMAL mode (ELSE)

augroup cursorStyle
	autocmd!
	" Set cursor on enter.
	autocmd VimEnter * normal! :startinsert :stopinsert
	" Restore terminal cursor on exit.
	autocmd VimLeave * silent !echo -ne "\e[6 q"
augroup END

" }}}

" File Sourcing
" source $MYVIMDIR/statusline.vim


