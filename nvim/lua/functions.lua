local M = {}

-- Usage extend_hl('Comment', 'StatusLine', { italic = true })
-- From: https://www.reddit.com/r/neovim/comments/yexeil/comment/iu0lbgt/?utm_source=share&utm_medium=web2x&context=3
function M.ExtendHL(base, name, def)
	local current_def = vim.api.nvim_get_hl_by_name(base, true)
	local new_def = vim.tbl_extend("force", current_def, def)

	vim.api.nvim_set_hl(0, name, new_def)
end

function M.SaveAll()
	local original_cursor = vim.fn.winsaveview()
	-- vim.lsp.buf.format()
	vim.cmd([[:wa]])
	vim.fn.winrestview(original_cursor)
end

-- From: https://stackoverflow.com/a/70730552/10439539
function M.preserve(arguments)
	local fullArguments = string.format("keepjumps keeppatterns execute %q", arguments)
	-- local original_cursor = vim.fn.winsaveview()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	vim.api.nvim_command(fullArguments)
	local lastline = vim.fn.line("$")
	-- vim.fn.winrestview(original_cursor)
	if line > lastline then
		line = lastline
	end
	vim.api.nvim_win_set_cursor(0, { line, col })
end

-- Adapted From: https://vi.stackexchange.com/questions/24367/unexpected-behavior-with-feedkeys
function M.YankFixedCursor(motionPrefix)
	vim.o.operatorfunc = "v:lua.require'functions'.SendToClip"
	-- Set mark z to current cursor pos to restore to later
	return "mzg@" .. motionPrefix
end

-- Adapted From: https://stackoverflow.com/a/58822884/10439539
function M.SendToClip(type, format)
	local defaultFormat = true
	-- From: https://stackoverflow.com/a/66003880/10439539
	format = format or (format == nil and defaultFormat)

	if type == "v" then
		-- Visual mode
		vim.cmd([[keepjumps silent! normal! mz"0y]])
	elseif type == "line" then
		vim.cmd([[keepjumps silent! normal! '[V']"0y]])
	elseif type == "char" then
		vim.cmd([[keepjumps silent! normal! `[v`]"0y]])
	end

	local output = vim.fn.getreg("0")
	if format == true then
		-- From: https://stackoverflow.com/a/20076502/10439539
		output = vim.fn.substitute(output, "\\s\\{2,}\\|\\n$", "", "g")
	end
	-- Yanking to + register does not work for some reason. So use win32yank.exe instead.
	vim.fn.system("win32yank.exe -i --crlf", output)
	vim.api.nvim_win_set_cursor(0, vim.api.nvim_buf_get_mark(0, "z"))
end

function M.FormatPaste(reg, command)
	local line, col = unpack(vim.api.nvim_win_get_cursor(0)) -- Save cursor position

	local register = reg == '"' and '"0' or '"' .. reg
	vim.cmd("normal! " .. register .. command)

	local mode = vim.fn.getregtype(vim.v.register):sub(1, 1)
	if mode == "v" then
		-- Character mode
		vim.cmd([[keepjumps normal gV]])
		vim.cmd([[keepjumps normal =]])
		vim.cmd([[keepjumps normal ^]])
	elseif mode == "V" then
		-- The commands don't work when they are combined. When they're
		-- combined, it's like they're working with stale/old data.
		vim.cmd([[keepjumps normal gV]])
		vim.cmd([[keepjumps normal =]])
		vim.cmd([[keepjumps normal ^]])
	elseif mode == "\\<C-V>" then
		-- Visual-Block mode
		return nil
	end

	-- Restore cursor position
	local lastline = vim.fn.line("$")
	if line > lastline then
		line = lastline
	end
	vim.api.nvim_win_set_cursor(0, { line, col })
end

-- Function to check if a floating dialog exists and if not
-- then check for diagnostics under the cursor
-- Can be used for CursorHover Diagnostics
function M.OpenDiagnosticIfNoFloat()
	-- for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
	-- 	if vim.api.nvim_win_get_config(winid).zindex then
	-- 		return
	-- 	end
	-- end

	-- THIS IS FOR BUILTIN LSP
	vim.diagnostic.open_float({
		scope = "cursor",
		focusable = false,
		close_events = {
			"CursorMoved",
			"CursorMovedI",
			"BufHidden",
			"InsertCharPre",
			"WinLeave",
		},
	}, 0)
end

-- From: https://github.com/neovim/neovim/issues/21985#issuecomment-1402056008
-- Currently unused
function M.get_diagnostic_at_cursor()
	local cur_buf = vim.api.nvim_get_current_buf()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	local entrys = vim.diagnostic.get(cur_buf, { lnum = line - 1 })
	local res = {}
	for _, v in pairs(entrys) do
		if v.col <= col and v.end_col >= col then
			table.insert(res, {
				code = v.code,
				message = v.message,
				range = {
					["start"] = {
						character = v.col,
						line = v.lnum,
					},
					["end"] = {
						character = v.end_col,
						line = v.end_lnum,
					},
				},
				severity = v.severity,
				source = v.source or nil,
			})
		end
	end
	return res
end

-- Show working directory in statusline
function _G.Statusline_Getcwd()
	if vim.bo.filetype ~= "help" and vim.bo.filetype ~= "man" and vim.bo.buftype ~= "terminal" then
		local path = vim.fn.fnamemodify(vim.fn.getcwd(0), ":~")

		return vim.fn.pathshorten(path, math.floor(vim.fn.winwidth(0) * 0.1))
	else
		return ""
	end
end

-- Show search count in statusline
function _G.Statusline_Search()
	if vim.v.hlsearch == 1 then
		-- searchcount can fail e.g. if unbalanced braces in search pattern
		local ok, searchcount = pcall(vim.fn.searchcount)

		if ok and searchcount["total"] > 0 then
			return "‹" .. "⚲ " .. searchcount["current"] .. "∕" .. searchcount["total"] .. "›"
		end
	end

	return ""
end

-- Show macro recoring message in statusline
function _G.Statusline_MacroRecording()
	local recording_register = vim.fn.reg_recording()

	if recording_register == "" then
		return ""
	else
		return "‹" .. "rec @" .. recording_register .. "›"
	end
end

function _G.logFile(message)
	local log_file_path = vim.env.MYNEOVIMDIR .. "/output.log"
	local log_file = io.open(log_file_path, "a")
	if log_file == nil then
		return
	end

	io.output(log_file)
	io.write(message .. "\n")
	io.close(log_file)
end

return M
