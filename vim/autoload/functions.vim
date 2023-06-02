" command! -nargs=* -bang RG call functions#RipgrepFzf(<q-args>, <bang>0)
function! functions#RipgrepFzf(query, fullscreen)
	let command_fmt = "rg --line-number --no-heading --follow --hidden --no-ignore --glob='!.git/' --color=always --smart-case -- %s || true"
	let initial_command = printf(command_fmt, shellescape(a:query))
	let reload_command = printf(command_fmt, '{q}')
	let spec = {'options': ['--disabled', '--query', a:query, '--bind', 'change:reload:sleep 0.1;'.reload_command]}
	let spec = fzf#vim#with_preview(spec, 'right', 'ctrl-/')
	call fzf#vim#grep(initial_command, 1, spec, a:fullscreen)
endfunction

function! functions#SaveAndReload()
	let l:view = winsaveview()

	silent! exec "w"
	" exec "mksession! " . $MYVIMDIR . "/sessions/session.vim"
	silent! normal \vr
	redraw
	echom (v:shell_error > 0 ? ('Error: ' . v:shell_error) : 'Save & Reload Successful')

	call winrestview(l:view)
endfunction

if !exists('*Preserve')
	function! functions#FixDOSLineEndings(command, ...)
		try
			let l:win_view = winsaveview()
			"silent! keepjumps keeppatterns execute a:command
			execute 'keepjumps keeppatterns ' . a:command
		finally
			call winrestview(l:win_view)
		endtry
	endfunction
endif

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
		normal! p
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

