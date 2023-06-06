
" FZF --------------------------------------------------------{{{
" command! -nargs=* -bang RG call functions#RipgrepFzf(<q-args>, <bang>0)
function! functions#RipgrepFzf(query, fullscreen)
	let command_fmt = "rg --line-number --no-heading --follow --hidden --ignore --glob='!.git/' --color=always --smart-case -- %s || true"
	let initial_command = printf(command_fmt, shellescape(a:query))
	let reload_command = printf(command_fmt, '{q}')
	let spec = {'options': ['--disabled', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
	let spec = fzf#vim#with_preview(spec, 'right', 'ctrl-/')
	call fzf#vim#grep(initial_command, 1, spec, a:fullscreen)
endfunction

" ------------------------------------------------------------------
" Buffers - Taken from fzf.vim/autoload/fzf/vim.vim
" Changes:
" 	- new s:openBufID function
" 	- Modified bufopen() to allow for opening or deletion of 1 or more buffers.
" ------------------------------------------------------------------
let s:default_action = {
			\ 'ctrl-t': 'tab split',
			\ 'ctrl-x': 'split',
			\ 'ctrl-v': 'vsplit' }

let s:TYPE = {'dict': type({}), 'funcref': type(function('call')), 'string': type(''), 'list': type([])}

function! s:action_for(key, ...)
	let default = a:0 ? a:1 : ''
	let Cmd = get(get(g:, 'fzf_action', s:default_action), a:key, default)
	return type(Cmd) == s:TYPE.string ? Cmd : default
endfunction

function! s:find_open_window(b)
	let [tcur, tcnt] = [tabpagenr() - 1, tabpagenr('$')]
	for toff in range(0, tabpagenr('$') - 1)
		let t = (tcur + toff) % tcnt + 1
		let buffers = tabpagebuflist(t)
		for w in range(1, len(buffers))
			let b = buffers[w - 1]
			if b == a:b
				return [t, w]
			endif
		endfor
	endfor
	return [0, 0]
endfunction

function! s:jump(t, w)
	execute a:t.'tabnext'
	execute a:w.'wincmd w'
endfunction

function! s:openBufID(action, ID)
	if empty(a:action) && get(g:, 'fzf_buffers_jump')
		let [t, w] = s:find_open_window(a:ID)
		if t
			call s:jump(t, w)
			return
		endif
	endif
	let cmd = s:action_for(a:action)
	if !empty(cmd)
		execute 'silent' cmd
	endif
	execute 'buffer' a:ID
endfunction

function! functions#bufopen(lines)
	if len(a:lines) < 2
		return
	endif

	if len(a:lines) == 2
		let b = matchstr(a:lines[1], '\[\zs[0-9]*\ze\]')
		call s:openBufID(a:lines[0], b)
	else
		let l:keybind = remove(a:lines, 0)
		let l:splitLines = join(map(a:lines, {_, line -> split(line)[2]}))
		let l:bufIDs = []
		call substitute(l:splitLines, '\[\zs[0-9]*\ze\]', '\=add(l:bufIDs, submatch(0))', 'g')
		for bufID in l:bufIDs
			call s:openBufID(l:keybind, bufID)
		endfor
	endif
endfunction

" }}}

function! functions#SaveAndReload()
	let l:view = winsaveview()

	silent! exec "w"
	" exec "mksession! " . $MYVIMDIR . "/sessions/session.vim"
	silent! normal \vr
	redraw
	echom (v:shell_error > 0 ? ('Error: ' . v:shell_error) : 'Save & Reload Successful')

	call winrestview(l:view)
endfunction

function! functions#HorizontalScrollMode( call_char )
	if &wrap
		return
	endif

	echohl Title
	let typed_char = a:call_char
	while index( [ 'h', 'l', 'H', 'L' ], typed_char ) != -1
		execute 'normal! z'.typed_char
		redraws
		echon '-- Horizontal scrolling mode (h/l/H/L)'
		let typed_char = nr2char(getchar())
	endwhile
	echohl None | echo '' | redraws
endfunction

if g:USING_WSL
	function! functions#FixDOSLineEndings(command, ...)
		let l:save = winsaveview()
		if a:0
			silent execute 'keepjumps normal g' . visualmode() . a:command . '<C-O>gV'
			silent! keepjumps lockmarks keeppatterns %s/\r//g
		else
			silent execute 'keepjumps normal ' . a:command . 'gV'
			silent! keepjumps lockmarks keeppatterns %s/\r//g
			call feedkeys("\<Esc>", 'x')
			call feedkeys("gV=", 'x')
		endif
		call winrestview(l:save)
	endfunction

	" From: https://vi.stackexchange.com/questions/24367/unexpected-behavior-with-feedkeys
	function! functions#YankFixedCursor(motionPrefix)
		let g:myfixedcursor = getcurpos()
		set operatorfunc=functions#SendToClip
		return 'g@' . a:motionPrefix
	endfunction

	" From: https://stackoverflow.com/a/58822884/10439539
	function! functions#SendToClip(type, ...)
		if a:0
			let g:myfixedcursor = getcurpos()
			" Visual mode
			keepjumps silent! normal! gv"0y
		elseif a:type ==# 'line'
			keepjumps silent! normal! '[V']"0y
		elseif a:type ==# 'char'
			keepjumps silent! normal! `[v`]"0y
		endif

		" From: https://stackoverflow.com/a/20076502/10439539
		let l:stripedOutput = substitute(@0, '\s\{2,}\|\n$', '', 'g')
		" Yanking to + register does not work for some reason. So use
		" System32/clip.exe instead.
		call system('clip.exe', l:stripedOutput)
		call setpos('.', g:myfixedcursor)
	endfunction
endif

" From: https://stackoverflow.com/questions/5172323/how-to-properly-extend-a-highlighting-group-in-vim
function! functions#ExtendHighlight(base, group, add)
	redir => basehi
	sil! exec 'highlight' a:base
	redir END
	let grphi = split(basehi, '\n')[0]
	let grphi = substitute(grphi, '^'.a:base.'\s\+xxx', '', '')
	exec 'highlight' a:group grphi a:add
endfunction

function! functions#FormatPaste(register, command, ...)
	if a:0
		let l:register = a:register ==# '"' ? '"0' : '"' . a:register
		exec 'normal! ' . l:register . a:command
	else
		exec 'normal! ' . a:command
	endif

	let l:mode = getregtype(v:register)[0]
	if l:mode ==# 'v'
		" Character mode
	elseif l:mode ==# 'V'
		" The commands don't work when they are combined. When they're
		" combined, it's like they're working with stale/old data.
		keepjumps normal gV
		keepjumps normal =
		keepjumps normal ^
	elseif l:mode ==# "\<C-V>"
		" Visual-Block mode
	endif
endfunction

function! functions#NetrwRemoveRecursive()
	if &filetype ==# 'netrw'
		cnoremap <buffer> <CR> rm -r<CR>
		normal mu
		normal mf

		try
			normal mx
		catch
			echo "Canceled"
		endtry

		cunmap <buffer> <CR>
	endif
endfunction

" LIGHTLINE ----------------------------------------------------------------{{{

function! functions#LightlineFilename()
	let root = fnamemodify(get(b:, 'git_dir'), ':h')
	let path = expand('%:p')
	if path[:len(root)-1] ==# root
		return path[len(root)+1:]
	endif
	return expand('%')
endfunction

function! functions#LightlineFileformat()
	return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! functions#LightlineFiletype()
	return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! functions#LightlineReadonly()
	" return &readonly && &filetype !=# 'help' ? '' : ''
	return &readonly ? "\uf023" : ''
endfunction

function! functions#MyFugitiveHead()
	let head = FugitiveHead()
	if head != ""
		let head = "\uf126 " .. head
		let head = head . " [" . s:gitSyncData[0] . "\uea9a " . s:gitSyncData[1] . "\ueaa1]"
	endif

	return head
endfunction

let s:syncJob = -1
let s:gitSyncData = ["?", "?"]
function! functions#Receive(job, status)
	let head = FugitiveHead()
	if head == ""
		let s:gitSyncData = ["?", "?"]
	else
		" Get count, awk to clean up output, then tr to remove trailing newline
		let s:gitSyncData = system("git rev-list --left-right --count  origin/" . head . "..." . head . " | awk '{print $1 \" \" $2}' | tr -d '\\n'")
		let s:gitSyncData = split(s:gitSyncData, ' ')
	endif
endfunction

function! functions#GitFetch(time)
	let s:syncJob = job_start('git fetch', {'exit_cb': 'functions#Receive'})
endfunction

" }}}
