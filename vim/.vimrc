"           ,---------------------------------.    ,--
"            || o      /\  o     o       o    ||    ||
"            |,-------------------------------.|    |,-
"        ,--.||    o  /  \    o             o ||    ||o
"     -. \    `. o   /-..-\         o       ,-:|    ||
"       \ )    _\  /\/    \     o          :   \    ||
"        )),;;'(. /  \  o  \o           o  |    )   ||
"       / ((.`   >/`'\.__..-\/\    /\      |   /    ||
"       \  ))   

set encoding=utf-8
scriptencoding utf-8
" Disable vi compatibility, if for some reason it's on.
if &compatible
	set nocompatible
endif

" File Paths ---------------------------------------------------------------- {{{
" From -  https://github.com/z0rc/dot files/blob/main/vim/vimrc
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

" Enable backups
set backup

" Enable undo file
set undofile

" Enable type file detection. Vim will be able to try to detect the type of file is use.
filetype on

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

" Turn syntax highlighting on.
syntax on

if executable("rg")
	set grepprg=rg\ --vimgrep\ --smart-case\ --hidden
	set grepformat=%f:%l:%c:%m
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
" set showmode

" Show matching words during a search.
set showmatch

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

" PLUGINS ---------------------------------------------------------------- {{{

" PLUGIN LOADER AUTOMATION ----------------------------------------------- {{{
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

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'matze/vim-move'
Plug 'tpope/vim-surround'
Plug 'junegunn/vim-peekaboo'
Plug 'tpope/vim-commentary'
Plug 'machakann/vim-highlightedyank'
Plug 'andymass/vim-matchup'
Plug 'junegunn/vim-slash'

" ---- Theme/Colors ----
Plug 'catppuccin/vim', { 'as': 'catppuccin' }

call plug#end()

" }}}

" PLUGIN SETTINGS -------------------------------------------------------- {{{
let g:move_key_modifier = 'S'
let g:move_key_modifier_visualmode = 'S'

let g:highlightedyank_highlight_duration = 500

" }}}

" MAPPINGS ---------------------------------------------------------------- {{{

" Set <space> as the leader key
let mapleader = ' '

" Edit vimrc configuration file
nnoremap \ve :e $MYVIMRC<CR>
" Edit statusline configuration file
nnoremap \vs :e $MYVIMDIR/statusline.vim<CR>
" Reload vimrc configuration file
nnoremap \vr :source $MYVIMRC<CR>

" Fzf file search
nnoremap <C-P> :Files<CR>
command! -bang -nargs=? -complete=dir Files
			\ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)
command! -bang -nargs=* Rg
			\ call fzf#vim#grep("rg --column --line-number --no-ignore --no-heading --hidden --follow --glob '!.git/*' --color=always --smart-case -- " . shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0)

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

" <C-O> in insert mode - toggles in and out of insert to normal mode.
" <C-U> in normal mode will clear the extra range/info after a : is pressed,
" (:'<,'> in visual mode) just leaving the : in the command line.
nnoremap <silent> <expr> <M-Up> ":copy .-1<CR>==" .. (v:count1 - 1 == 0 ? "" : (v:count1 - 1) .. "k")
nnoremap <silent> <expr> <M-Down> 'm`' .. v:count1 .. ':<C-U>copy .<CR>==``'
vnoremap <silent> <M-Up>    :<C-U>exec "'<,'>copy '<-" . (1+v:count1)<CR>gv
vnoremap <silent> <M-Down>  :<C-U>exec "'<,'>copy '>+" . (0+v:count1)<CR>gv

" }}}

" VIMSCRIPT -------------------------------------------------------------- {{{

" This will enable code folding.
" Use the marker method of folding.
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" }}}

" Set color scheme & settings
set termguicolors
colorscheme catppuccin_$THEMEVARIANT

" File Sourcing
source $MYVIMDIR/statusline.vim

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
" Set cursor on enter.
autocmd VimEnter * silent !echo -ne "\e[2 q"
" Restore terminal cursor on exit.
autocmd VimLeave * silent !echo -ne "\e[6 q"
