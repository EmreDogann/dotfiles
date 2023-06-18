local M = {}

-- Usage extend_hl('Comment', 'StatusLine', { italic = true })
-- From: https://www.reddit.com/r/neovim/comments/yexeil/comment/iu0lbgt/?utm_source=share&utm_medium=web2x&context=3
function M.extend_hl(base, name, def)
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

-- Adapted From: https://vi.stackexchange.com/questions/24367/unexpected-behavior-with-feedkeys
function M.YankFixedCursor(motionPrefix)
	vim.o.operatorfunc = "v:lua.require'functions'.SendToClip"
	-- Set mark z to current cursor pos to restore to later
	return "mzg@" .. motionPrefix
end

-- Adapted From: https://stackoverflow.com/a/58822884/10439539
function M.SendToClip(type, visualMode)
	if visualMode ~= nil then
		-- Visual mode
		vim.cmd([[keepjumps silent! normal! mzgv"0y]])
	elseif type == "line" then
		vim.cmd([[keepjumps silent! normal! '[V']"0y]])
	elseif type == "char" then
		vim.cmd([[keepjumps silent! normal! `[v`]"0y]])
	end

	-- From: https://stackoverflow.com/a/20076502/10439539
	local stripedOutput = vim.fn.substitute(vim.fn.getreg("0"), "\\s\\{2,}\\|\\n$", "", "g")
	-- Yanking to + register does not work for some reason. So use win32yank.exe instead.
	vim.fn.system("win32yank.exe -i --crlf", stripedOutput)
	vim.api.nvim_win_set_cursor(0, vim.api.nvim_buf_get_mark(0, "z"))
end

function M.FormatPaste(reg, command)
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

-- Show working directory in statusline
function _G.Statusline_Getcwd()
	if vim.bo.filetype ~= "help" and vim.bo.filetype ~= "man" and vim.bo.buftype ~= "terminal" then
		local path = vim.fn.fnamemodify(vim.fn.getcwd(0), ":~")

		return vim.fn.pathshorten(path, math.floor(vim.fn.winwidth(0) * 0.03))
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

return M
