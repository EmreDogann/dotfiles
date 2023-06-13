local M = {}

-- Usage extend_hl('Comment', 'StatusLine', { italic = true })
-- From: https://www.reddit.com/r/neovim/comments/yexeil/comment/iu0lbgt/?utm_source=share&utm_medium=web2x&context=3
function M.extend_hl(base, name, def)
	local current_def = vim.api.nvim_get_hl_by_name(base, true)
	local new_def = vim.tbl_extend('force', current_def, def)

	vim.api.nvim_set_hl(0, name, new_def)
end

-- function M.SaveAndReload()
-- 	local original_cursor = vim.fn.winsaveview()
-- 	vim.cmd("silent! exec 'w'")
-- 	vim.cmd("silent! exec \\vr")
-- 	vim.fn.winrestview(original_cursor)
-- end

-- Adapted From: https://vi.stackexchange.com/questions/24367/unexpected-behavior-with-feedkeys
function M.YankFixedCursor(motionPrefix)
	myfixedcursor = vim.api.nvim_win_get_cursor(0)
	vim.api.nvim_set_operatorfunc(M.SendToClip)
	return 'g@' .. motionPrefix
end

-- Adapted From: https://stackoverflow.com/a/58822884/10439539
function M.SendToClip(type, visualMode)
	if visualMode ~= nil then
		myfixedcursor = vim.api.nvim_win_get_cursor(0)
		-- Visual mode
		vim.cmd([[keepjumps silent! normal! gv"0y]])
	elseif type ==# 'line' then
		vim.cmd([[keepjumps silent! normal! '[V']"0y]])
	elseif type ==# 'char' then
		vim.cmd([[keepjumps silent! normal! `[v`]"0y]])
	end

	-- From: https://stackoverflow.com/a/20076502/10439539
	local stripedOutput = vim.fn.substitute(vim.fn.getreg('0'), '\\s\\{2,}\\|\\n$', '', 'g')
	-- Yanking to + register does not work for some reason. So use
	-- System32/clip.exe instead.
	vim.cmd([[silent! normal! "+y]])
	-- call system('clip.exe', l:stripedOutput)
	vim.api.nvim_win_set_cursor(0, myfixedcursor)
end

return M
