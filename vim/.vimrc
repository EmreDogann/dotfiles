set encoding=utf-8
scriptencoding utf-8

let g:USING_WSL = has("unix") && system("uname -r") =~ "microsoft"

" File Paths {{{
" From -  https://github.com/z0rc/dotfiles/blob/main/vim/vimrc
" Set default 'runtimepath' without ~/.vim folders
let &runtimepath=printf('%s/vimfiles,%s,%s/vimfiles/after', $VIM, $VIMRUNTIME, $VIM)
" What is the name of the directory containing this file?
let s:portable=expand('<sfile>:p:h')
" Add the directory to 'runtimepath'
let &runtimepath=printf('%s,%s,%s/after', s:portable, &runtimepath, s:portable)
let &packpath=&runtimepath
" let g:session_dir = expand('%:p:h') . '/sessions'
let g:session_dir = $MYVIMDIR . '/sessions'

" Set directory for swap & backup files.
" // - Ensures files created are uniquely named.
set directory=$MYVIMDIR/swap//
set viminfo='50,<1000,s100,:100,h,n$MYVIMDIR/.viminfo
set viewdir=$MYVIMDIR/views//
set backupdir=$MYVIMDIR/backup//
set undodir=$MYVIMDIR/undo//
set spellfile=$MYVIMDIR/spell/en.utf-8.add

" }}}

" GENERAL {{{
" Enable backups
set backup

" Enable undo file
set undofile

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

" Enable type file detection. Vim will be able to try to detect the type of file is use.
filetype on

" Enable plugins and load plugin for the detected file type.
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
set ttimeoutlen=10 " Under 10 causes cursor glitching when exiting insert mode.
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

" Set shift width to 4 spaces.
set shiftwidth=4

" Set tab width to 4 columns.
set tabstop=4

" Mix of tabs and space
set softtabstop=4

" Indent guides
set list listchars=trail:·,extends:»,precedes:«,nbsp:×
set listchars=tab:\\u258f\ 

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
set sidescrolloff=5

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

" Don't show the mode you are on the last line.
set noshowmode

" Show matching words during a search.
" set showmatch

" Highlight during a search. But not when sourcing .vimrc
set hlsearch
let @/ = ""

" Set the commands to save in history default number is 20.
set history=1000

" Enable auto completion menu after pressing TAB.
set wildmenu

" Make wildmenu behave like similar to Bash completion.
set wildmode=list:full

" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore+=*.swp,*.bak
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
set wildignore+=*/.git/**/*,*/.hg/**/*,*/.svn/**/*

" Case insensitive tab completion
set wildignorecase

" Start with all folds open
set foldlevelstart=99

" Keep changes to the buffer without writing them to the file.
set hidden

" Automatically save changed made to the buffer
set autowrite

" Don't redraw screen immediately if executing something that was not typed
set lazyredraw

" Session & View options
set sessionoptions-=options
" set sessionoptions-=folds
set viewoptions=cursor,folds,slash,unix

" Open new split panes to right and bottom, more natural than defaults.
set splitbelow
set splitright

" Status Line Options
set laststatus=2

" Netrw options
let g:netrw_keepdir = 0
let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_winsize = 25
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_list_hide = &wildignore

" Must be set before clever-f is loaded
let g:clever_f_mark_char_color='CustomCleverFCharColor'

" Tabline
set showtabline=2

" Bufferline
" From: https://www.reddit.com/r/vim/comments/11tdlx0/comment/jckkknq/?utm_source=share&utm_medium=web2x&context=3
" source $MYVIMDIR/autoload/bufferline.vim

" }}}

" PLUGINS {{{

" PLUGIN LOADER AUTOMATION {{{
let data_dir = has('nvim') ? stdpath('data') . '/site' : expand('$MYVIMDIR')
if empty(glob(data_dir . '/autoload/plug.vim'))
	silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Run PlugInstall if there are missing plugins
augroup Plug
	autocmd!
	autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
				\| PlugInstall --sync | source $MYVIMRC
				\| endif
augroup END

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
Plug 'rhysd/clever-f.vim'
Plug 'tpope/vim-fugitive'
Plug 'tmsvg/pear-tree'
Plug 'airblade/vim-rooter'
Plug 'jrudess/vim-foldtext'

" ---- Session Management ----
Plug 'tpope/vim-obsession'
" Plug 'zhimsel/vim-stay'
" Plug 'Konfekt/FastFold'

" ---- Code Completion/Semantic Highlighting ----
Plug 'sheerun/vim-polyglot'
Plug 'neoclide/coc.nvim', {'for': ['zig','cmake','rust',
			\'java','json', 'haskell', 'ts','sh', 'cs',
			\'yaml', 'c', 'cpp', 'd', 'go',
			\'python', 'dart', 'javascript', 'vim'], 'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
Plug 'ilyachur/cmake4vim'

" ---- Theme/Colors ----
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }

call plug#end()

" }}}

" PLUGIN SETTINGS {{{

" Set color scheme & settings
set termguicolors
colorscheme catppuccin_$THEMEVARIANT

" Turn syntax highlighting on.
if !exists("g:syntax_on")
	syntax enable
endif

" Change vertical split color
highlight! link VertSplit SignColumn

" Change indent guides and trailing spaces color
highlight SpecialKey term=standout ctermfg=240 ctermbg=235 guifg=#40455d guibg=#303446

" More subtle folded text highlighting
highlight Folded term=reverse ctermbg=236 guibg=#3c4052

" Clever-f settings
let g:clever_f_show_prompt=1
" let g:clever_f_mark_direct=1
let g:clever_f_smart_case=1
let g:clever_f_across_no_line=1
let g:clever_f_fix_key_direction=1
call functions#ExtendHighlight('Error', 'CustomCleverFCharColor', 'cterm=underline')

" matze/vim-move settings
let g:move_key_modifier = 'S'
let g:move_key_modifier_visualmode = 'S'

" machakann/vim-highlightedyank settings
let g:highlightedyank_highlight_duration = 300
let g:highlightedyank_highlight_in_visual = 0

" airblade/vim-rooter settings
let g:rooter_silent_chdir = 1
let g:rooter_resolve_links = 1

" tmsvg/pear-tree settings
let g:pear_tree_smart_openers = 1
let g:pear_tree_smart_closers = 1
let g:pear_tree_smart_backspace = 1
" Disable automapping so we can fix Coc mapping.
let g:pear_tree_map_special_keys = 0

" Default mappings:
imap <BS> <Plug>(PearTreeBackspace)
" Prevent <Esc> mapping from breaking cursor keys and Shift-Tab in insert mode
" From: https://github.com/tmsvg/pear-tree/blob/4b29b87a5020b51e65febb477581555cdc4d629e/plugin/pear-tree.vim#L177
imap <buffer> <Esc><Esc> <Plug>(PearTreeFinishExpansion)
imap <buffer> <nowait> <Esc> <Plug>(PearTreeFinishExpansion)

function! CustomCR() abort
	" Make <CR> to accept selected completion item or notify coc.nvim to format.
	if coc#pum#visible()
		return coc#_select_confirm()
	else
		" Undo each individual enter action as opposed to undo in blocks.
		" call feedkeys("\<C-g>u")
		call coc#on_enter()
		return "\<Plug>(PearTreeExpand)"
endfunction

" Get PearTreeExpand working with coc.nvim
imap <silent><expr> <CR> CustomCR()

" FZF.vim {{{
function! s:BuffersSink(lines)
	if a:lines[0] ==# 'ctrl-r'
		call remove(a:lines, 0)
		let l:splitLines = join(map(a:lines, {_, line -> split(line)[2]}))
		let l:bufIDs = []
		call substitute(l:splitLines, '\[\zs[0-9]*\ze\]', '\=add(l:bufIDs, submatch(0))', 'g')

		execute 'bwipeout' join(l:bufIDs)
	elseif a:lines[0] ==# 'alt-r'
		call remove(a:lines, 0)
		let l:splitLines = join(map(a:lines, {_, line -> split(line)[2]}))
		" Add the current buffer to the list of buffers we want to keep.
		let l:bufIDs = [string(bufnr("%"))]
		call substitute(l:splitLines, '\[\zs[0-9]*\ze\]', '\=add(l:bufIDs, submatch(0))', 'g')

		let l:buffersToRemove = filter(map(copy(getbufinfo()), 'v:val.bufnr'), 'index(l:bufIDs, string(v:val)) == -1')
		execute 'bwipeout' join(l:buffersToRemove)
	else
		call functions#bufopen(a:lines)
	endif
endfunction

function! s:BuffersCmd(...)
	let [query, args] = (a:0 && type(a:1) == type('')) ?
				\ [a:1, a:000[1:]] : ['', a:000]
	let sorted = fzf#vim#_buflisted_sorted()
	let header_lines = '--header-lines=' . (bufnr('') == get(sorted, 0, 0) ? 1 : 0)
	let tabstop = len(max(sorted)) >= 4 ? 9 : 8
	return fzf#run(fzf#vim#with_preview(fzf#wrap('Delete Buffers', {
				\ 'source':  map(sorted, 'fzf#vim#_format_buffer(v:val)'),
				\ 'sink*': { lines -> s:BuffersSink(lines) },
				\ 'options': ['+m', '-x', '--tiebreak=index', header_lines, '--ansi', '-d', '\t',
				\ '--with-nth', '3..', '-n', '2,1..2', '--prompt', 'Buf> ', '--query', query,
				\ '--preview-window', '+{2}-/2', '--tabstop', tabstop, '--layout=reverse', '--info=inline', '--multi',
				\ '--expect', 'ctrl-t,ctrl-x,ctrl-s,ctrl-r,alt-r', '--bind', 'ctrl-a:select-all,ctrl-d:deselect-all'],
				\ 'window': {'width': 0.45, 'height': 0.4, 'relative': v:false}
				\}, args[0]), "right:55%:<50(up:40%)"))
endfunction

let g:fzf_preview_window = ['right,50%,<70(up,40%)', 'ctrl-/']
let g:fzf_action = {
			\ 'ctrl-t': 'tab split',
			\ 'ctrl-s': 'split',
			\ 'ctrl-x': 'vsplit' }

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up.
let g:fzf_history_dir = '$HOME/.local/share/fzf-history'
let g:fzf_tags_command = 'ctags -R'

command! -bang -nargs=? -complete=dir Files
			\ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)
command! -bang -nargs=? -complete=dir GFiles
			\ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)
command! -bang -nargs=* Rg
			\ call fzf#vim#grep("rg --line-number --no-heading --hidden --follow --glob='!.git/' --color=always --smart-case -- " . shellescape(<q-args>),
			\ 1, fzf#vim#with_preview({'options': '--delimiter : --nth 3..'}), <bang>0)
command! -bang -nargs=* Rgl
			\ call fzf#vim#grep("rg --hidden --follow --smart-case --no-heading --line-number --color=always --glob='!.git/' -- " . shellescape(<q-args>)
			\ . ' ' . expand("%:p:h"), 1, fzf#vim#with_preview({'options': '--delimiter : --nth 3..'}), <bang>0)
" command! -bang -nargs=* Rgr
" 			\ call fzf#vim#grep("rg --hidden --follow --smart-case --no-heading --line-number --color=always --glob='!.git/' -- " . shellescape(<q-args>)
" 			\ . ' ' . (system('git status') =~ '^fatal' ? expand("%:p:h") : system("git rev-parse --show-toplevel")), 1, fzf#vim#with_preview({'options': '--delimiter : --nth 3..'}), <bang>0)
command! -bang -nargs=? -complete=buffer Buffers call <SID>BuffersCmd(<q-args>, <bang>0)

" command! -nargs=* -bang RG call functions#RipgrepFzf(<q-args>, <bang>0)

" }}}

" Lightline {{{
let g:lightline = {
	\ 'colorscheme': 'catppuccin_' . $THEMEVARIANT,
	\ 'separator' : { 'left': "\ue0b4", 'right': "\ue0b6" },
	\ 'component' : {
		\   'lineinfo': '%3l:%-2v%<',
		\ },
	\ 'tabline': {
		\   'left': [ ['buffers'] ],
		\   'right': [ ['close'] ]
		\ },
	\ 'component_expand': {
		\   'buffers': 'lightline#bufferline#buffers'
		\ },
	\ 'component_type': {
		\   'buffers': 'tabsel'
		\ },
	\ 'component_function': {
		\	'filename': 'functions#LightlineFilename',
		\   'fileformat': 'functions#LightlineFileformat',
		\   'filetype': 'functions#LightlineFiletype',
		\   'readonly': 'functions#LightlineReadonly',
		\   'gitbranch': 'functions#MyFugitiveHead',
		\ 	'obsession': 'functions#MyObsessionStatus',
		\   'cocstatus': 'coc#status'
		\ },
	\ 'active' : {
		\   'right' : [['lineinfo', 'spell'], ['obsession', 'fileencoding', 'fileformat', 'filetype']],
		\   'left': [['mode', 'paste'], ['gitbranch', 'cocstatus', 'readonly', 'filename', 'modified']]
		\ },
	\'inactive' : {
		\ 'left': [['filename']],
		\ 'right': []
		\ }
\ }

" Colors taken from Catppuccin Vim Lightline color scheme file.
" Maccihato
" let s:mauve = [ "#C6A0F6", 183 ]
" let s:red = [ "#ED8796", 211 ]
" let s:yellow = [ "#EED49F", 223 ]
" let s:teal = [ "#8BD5CA", 152 ]
" let s:blue = [ "#8AADF4", 117 ]
" let s:overlay0 = [ "#6E738D", 243 ]
" let s:surface1 = [ "#494D64", 240 ]
" let s:surface0 = [ "#363A4F", 236 ]
" let s:base = [ "#24273A", 235 ]
" let s:mantle = [ "#1E2030", 234 ]

" Frappe
let s:mauve = [ "#CA9EE6", 183 ]
let s:red = [ "#E78284", 211 ]
let s:yellow = [ "#E5C890", 223 ]
let s:teal = [ "#81C8BE", 152 ]
let s:blue = [ "#8CAAEE", 117 ]
let s:overlay0 = [ "#737994", 243 ]
let s:surface1 = [ "#51576D", 240 ]
let s:surface0 = [ "#414559", 236 ]
let s:base = [ "#303446", 235 ]
let s:mantle = [ "#292C3C", 234 ]

let s:palette = g:lightline#colorscheme#{g:lightline.colorscheme}#palette
let s:palette.normal.left = [[s:mantle[0], s:blue[0], s:mantle[1], s:blue[1]], [s:blue[0], s:surface0[0], s:blue[1], s:surface0[1]]]
let s:palette.insert.left = [[s:mantle[0], s:teal[0], s:mantle[1], s:teal[1]], [s:teal[0], s:surface0[0], s:teal[1], s:surface0[1]]]
let s:palette.replace.left = [[s:mantle[0], s:red[0], s:mantle[1], s:red[1]], [s:red[0], s:surface0[0], s:red[1], s:surface0[1]]]
let s:palette.visual.left = [[s:mantle[0], s:mauve[0], s:mantle[1], s:mauve[1]], [s:mauve[0], s:surface0[0], s:mauve[1], s:surface0[1]]]

let s:palette.normal.right = s:palette.normal.left
let s:palette.insert.right = s:palette.insert.left
let s:palette.replace.right = s:palette.replace.left
let s:palette.visual.right = s:palette.visual.left
let s:palette.normal.middle = [[s:blue[0], s:mantle[0], s:blue[1], s:mantle[1]]]
let s:palette.inactive.middle = [[s:blue[0], s:mantle[0], s:blue[1], s:mantle[1]]]
let s:palette.inactive.left = s:palette.inactive.middle
let s:palette.inactive.right = s:palette.inactive.middle

let g:lightline#bufferline#show_number = 1
let g:lightline#bufferline#unicode_symbols = 1
let g:lightline#bufferline#modified = ' +'
let g:lightline#bufferline#read_only = " \uf023"

call timer_start(10000, function('functions#GitFetch'), {'repeat': -1})
call timer_start(10, function('functions#GitFetch')) " Run on startup

" }}}

" COC.nvim {{{
" Extensions to install if not already installed
let g:coc_global_extensions = ['coc-json', 'coc-clangd', 'coc-clang-format-style-options']

augroup CocStatus
	" Use autocmd to force lightline update.
	autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
augroup END

highlight! link CocSearch Special
highlight! link CocInlayHint Character
highlight! link CocSemVariable Normal

" use <tab> to trigger completion and navigate to the next complete item
inoremap <silent><expr> <Tab>
			\ coc#pum#visible() ? coc#pum#next(1) :
			\ CheckBackspace() ? "\<Tab>" :
			\ coc#refresh()
inoremap <silent><expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<C-H>"

function! CheckBackspace() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
	inoremap <silent><expr> <c-space> coc#refresh()
else
	inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
	if CocAction('hasProvider', 'hover')
		call CocActionAsync('doHover')
	else
		call feedkeys('K', 'in')
	endif
endfunction

" Highlight the symbol and its references when holding the cursor
" autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup CocGroup
	autocmd!
	" Setup formatexpr specified filetype(s)
	autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
	" Update signature help on jump placeholder
	autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
	nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
	nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
	inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
	inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
	vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
	vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" }}}

" FastFold {{{
" nmap <F4> <Plug>(FastFoldUpdate)
" let g:fastfold_force = 1
" let g:fastfold_minlines = 0
" let g:fastfold_savehook = 1
" let g:fastfold_fold_command_suffixes =  ['x','X','a','A','o','O','c','C']
" let g:fastfold_fold_movement_commands = [']z', '[z', 'zj', 'zk']
" let g:sh_fold_enabled = 7
" let g:zsh_fold_enable = 1
" let g:vimsyn_folding = 'af'
" let g:markdown_folding = 1

" }}}

" }}}

" MAPPINGS {{{

" Fix Alt key mappings not working in WSL
" From: https://github.com/vim/vim/issues/8726#issuecomment-894640707
" if g:USING_WSL
" 	execute "set <M-}>=\<Esc>}"
" 	execute "set <M-]>=\<Esc>]"
" 	execute "set <M-)>=\<Esc>)"
" 	execute "set <M-\'>=\<Esc>\'"
" 	" execute "set <M-e>=\<Esc>e"
" 	" <M-">
" 	execute "set <M-" . '\"' . ">=\<Esc>" . '\"'

" 	" From: https://stackoverflow.com/a/10216459/10439539
" 	let c='a'
" 	while c <= 'z'
" 		exec "set <M-".c.">=\<Esc>".c
" 		exec "imap \<ESC>".c." <M-".c.">"
" 		let c = nr2char(1+char2nr(c))
" 	endw
" endif

" Set <space> as the leader key
let mapleader = ' '

" Remap s to something else
" :map s

" Set mark, Save file, save session, reload, print status message, jump back
" to mark (original cursor position).
noremap <silent> <C-s> :call functions#SaveAndReload()<CR>

" Session management mappings
exec 'nnoremap <Leader>ss :Obsession ' . g:session_dir . '/*.vim<C-D><BS><BS><BS><BS><BS>'
exec 'nnoremap <Leader>sr :so ' . g:session_dir . '/*.vim<C-D><BS><BS><BS><BS><BS>'
" Pause session recording
nnoremap <Leader>sp :Obsession<CR>

" Yank to end of line instead of whole line.
nmap Y y$

" Paste from "0 register by default unless a register other than the default is specified.
" From: https://stackoverflow.com/questions/18391573/how-make-vim-paste-to-always-paste-from-register-0-unless-its-specified
nnoremap <silent> p :<C-U>call functions#FormatPaste(v:register, 'p', 1)<CR>
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

	" Clipboard copy bindings
	if executable("clip.exe")
		nnoremap <silent> <expr> cy functions#YankFixedCursor("")
		nnoremap <silent> <expr> cyy functions#YankFixedCursor("_")
		xnoremap <silent> Y :<C-U>call functions#SendToClip(visualmode(),1)<CR>
	endif
else
	nnoremap cp "+p
	nnoremap cP "+P
	xnoremap cp "+p
	xnoremap cP "+P
endif

" Insert sleep [x]m for debugging purposes
" nnoremap <leader>sl :<C-U>normal Osleep <C-R>=v:count1<CR>m<C-O>Oredraw<Esc>^

" Edit vimrc configuration file
nnoremap \ve :e $MYVIMRC<CR>
" Edit statusline configuration file
nnoremap \vcoc :CocConfig<CR>
" Reload vimrc configuration file
nnoremap \vr :source $MYVIMRC<CR>

" Horizontal Scrolling
nnoremap <silent> zh :call functions#HorizontalScrollMode('h')<CR>
nnoremap <silent> zl :call functions#HorizontalScrollMode('l')<CR>
nnoremap <silent> zH :call functions#HorizontalScrollMode('H')<CR>
nnoremap <silent> zL :call functions#HorizontalScrollMode('L')<CR>

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
nnoremap <expr> <C-P> (len(system('git rev-parse')) ? ':Files' : ':GFiles')."\<CR>"
nnoremap <leader>l :BLines<CR>
nnoremap <silent> <expr> <leader>b (v:count ? ':buf ' . v:count : ':Buffers') . "\<CR>"
nnoremap <silent> <leader><leader>b :buf #<CR>
nnoremap <leader>/ :Rg<CR>
" <C-_> is CTRL-/
nnoremap <leader><C-_> :Rgl<CR>
nnoremap <leader>t :Tags<CR>
nnoremap <leader>m :Marks<CR>
" nnoremap <silent> <Leader>g :Commits<CR>
nnoremap <silent> <Leader>? :Helptags<CR>
" nnoremap <silent> <Leader>hh :History<CR>
" nnoremap <silent> <Leader>h: :History:<CR>
" nnoremap <silent> <Leader>h/ :History/<CR> 

imap <c-x><c-l> <plug>(fzf-complete-line)
inoremap <expr> <c-x><c-f> fzf#vim#complete#path('fd')
inoremap <expr> <c-x><c-k> fzf#vim#complete#word('cat /usr/share/dict/words', {'window': { 'width': 0.2, 'height': 0.9, 'xoffset': 1 }})

" Toggle spell check.
nnoremap <silent> <F5> :setlocal spell!<CR>
inoremap <silent> <F5> <C-o>:setlocal spell!<CR>

" Automatically fix the last misspelled word and jump back to where you were.
"   Taken from this talk: https://www.youtube.com/watch?v=lwD8G1P52Sk
" nnoremap <Leader>sp :normal! mz[s1z=`z<CR>

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

" Buffer navigation
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

" Easier split navigation.
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap <leader>ee :Lexplore %:p:h<CR>
nnoremap <Leader>ea :Lexplore<CR>

function! NetrwMapping()
	" Navigation
	nmap <buffer> H u	" Go back in history
	nmap <buffer> h -^	" Go up one directory
	nmap <buffer> l <CR>	" open file or directory

	nmap <buffer> . gh		" Toggle dotfiles
	nmap <buffer> P <C-w>z	" Close preview

	nmap <buffer> L <CR>:Lexplore<CR>	" Open file and close Netrw
	nmap <buffer> <Leader>dd :Lexplore<CR>	" Close Netrw

	" Marks
	nmap <buffer> <TAB> mf
	nmap <buffer> <S-TAB> mF
	nmap <buffer> <Leader><TAB> mu

	" File Management
	nmap <buffer> ff %:w<CR>:buffer #<CR>	" Create file
	nmap <buffer> fr R	" Rename file
	nmap <buffer> fc mc	" Copy marked file
	nmap <buffer> fC mtmc	" After you mark your files, put the cursor in a directory and this will assign the target directory and copy.
	nmap <buffer> fm mm		" Move marked file
	nmap <buffer> fM mtmm	" Same as fC but for moving files
	nmap <buffer> f! mx		" Run external command on marked files

	" Recursive remove file or directory
	nmap <buffer> RR :call functions#NetrwRemoveRecursive()<CR>
endfunction

" }}}

" AUTOCOMMANDS {{{

" Use the marker method of folding.
augroup codeFolding
	autocmd!
	autocmd FileType vim setlocal foldmethod=marker
	autocmd FileType c,cpp setlocal foldmethod=syntax
augroup END

augroup colorScheme
	autocmd!
	autocmd ColorSchemePre * call functions#ExtendHighlight('Error', 'CustomCleverFCharColor', 'cterm=underline')
augroup END

augroup git
	autocmd!
	autocmd Filetype gitcommit setlocal spell textwidth=72
augroup END

augroup netrw_mapping
	autocmd!
	autocmd filetype netrw call NetrwMapping()
augroup END

augroup commentFormatting
	autocmd!
	autocmd FileType * set formatoptions-=cro
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

