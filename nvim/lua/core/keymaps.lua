local keymap = vim.keymap.set
local opts = { silent = true }
local optsExpr = vim.tbl_extend("force", opts, {expr = true})
local functions = require('functions')

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
-- keymap("n", "<C-Up>", ":resize -2<CR>", opts)
-- keymap("n", "<C-Down>", ":resize +2<CR>", opts)
-- keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
-- keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<Tab>", ":bnext<CR>", opts)
keymap("n", "<S-Tab>", ":bprevious<CR>", opts)

-- Close buffers
keymap("n", "<S-q>", "<cmd>bdelete!<CR>", opts)

-- Stay in indent mode when indenting
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- " Paste from "0 register by default unless a register other than the default is specified.
-- " From: https://stackoverflow.com/questions/18391573/how-make-vim-paste-to-always-paste-from-register-0-unless-its-specified
-- keymap("n", "p", "<cmd><C-U>call")
-- nnoremap <silent> p :<C-U>call functions#FormatPaste(v:register, 'p', 1)<CR>
-- nnoremap <silent> P :<C-U>call functions#FormatPaste(v:register, 'P', 1)<CR>
-- xnoremap <silent> p :<C-U>call functions#FormatPaste(v:register, 'p', 1)<CR>
-- xnoremap <silent> P :<C-U>call functions#FormatPaste(v:register, 'P', 1)<CR>

-- " Paste from default register (used for deleted text as a for of cut & paste).
-- nnoremap <silent> <leader>p :<C-U>call functions#FormatPaste('"', 'p')<CR>
-- nnoremap <silent> <leader>P :<C-U>call functions#FormatPaste('"', 'P')<CR>
-- xnoremap <silent> <leader>p :<C-U>call functions#FormatPaste('"', 'p')<CR>
-- xnoremap <silent> <leader>P :<C-U>call functions#FormatPaste('"', 'P')<CR>

-- nnoremap <silent> <expr> cy functions#YankFixedCursor("")
-- nnoremap <silent> <expr> cyy functions#YankFixedCursor("_")
-- xnoremap <silent> Y :<C-U>call functions#SendToClip(visualmode(),1)<CR>

-- keymap("n", "cy", functions.YankFixedCursor(""), optsExpr)
-- keymap("n", "cyy", functions.YankFixedCursor("_"), optsExpr)

keymap({"n", "x"}, "cp", "\"+p", opts)
keymap({"n", "x"}, "cP", "\"+P", opts)

-- " Select most recent pasted text
keymap("n", "gV", function()
	return "`[" .. vim.fn.getregtype(vim.v.register):sub(1,1) .. "`]"
end, optsExpr)

------ Plugin Mappings ------
-- nvim-notify
vim.keymap.set('n', '<leader>nc', function()
	require("notify").dismiss({ silent = true })
end, opts)

-- Harpoon
keymap("n", "<leader>ha", function()
	require('harpoon.mark').add_file()
end, opts)
keymap("n", "<leader>hh", function()
	require('harpoon.ui').toggle_quick_menu()
end, opts)
keymap("n", "<M-h>", function()
	require('harpoon.ui').nav_file(1)
end, opts)
keymap("n", "<M-j>", function()
	require('harpoon.ui').nav_file(2)
end, opts)
keymap("n", "<M-k>", function()
	require('harpoon.ui').nav_file(3)
end, opts)
keymap("n", "<M-l>", function()
	require('harpoon.ui').nav_file(4)
end, opts)

-- nvim-possession
keymap("n", "<leader>sl", function()
	require("nvim-possession").list()
end)
keymap("n", "<leader>sn", function()
	require("nvim-possession").new()
end)
keymap("n", "<leader>su", function()
	require("nvim-possession").update()
end)
keymap("n", "<leader>sd", function()
	require("nvim-possession").delete()
end)

-- FZF.lua
keymap("n", "<c-P>", function()
	require('fzf-lua').files()
end, opts)
keymap("n", "<leader>l", function()
	require('fzf-lua').blines()
end, opts)
keymap("n", "<leader>b", function()
	if vim.v.count ~= 0 then
		-- vim.cmd("buf " .. vim.v.count)
		vim.cmd("LualineBuffersJump " .. vim.v.count)
	else
		require('fzf-lua').buffers()
	end
end, opts)
keymap("n", "<leader>?", function()
	require('fzf-lua').help_tags()
end, opts)
keymap("n", "<leader>/", function()
	require('fzf-lua').grep_curbuf()
end, opts)
keymap("n", "<leader><C-_>", function()		-- <C-_> is CTRL-/
	require('fzf-lua').grep_project()
end, opts)
keymap("n", "<leader>t", function()
	require('fzf-lua').tags()
end, opts)
keymap("n", "<leader>m", function()
	require('fzf-lua').marks()
end, opts)
