local keymap = vim.keymap.set
local opts = { silent = true }
local optsExpr = vim.tbl_extend("force", opts, { expr = true })
local functions = require("functions")

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- Fast saving
keymap("n", "<C-s>", function()
	functions.SaveAll()
end, opts)

---- Auto indent on empty line.
keymap("n", "i", function()
	return string.match(vim.api.nvim_get_current_line(), "%g") == nil and '"_S' or "i"
end, { expr = true, noremap = true })
keymap("n", "a", function()
	return string.match(vim.api.nvim_get_current_line(), "%g") == nil and '"_S' or "a"
end, { expr = true, noremap = true })

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

-- Disable arrow keys
keymap("", "<Up>", ':echoerr "nono don be stopid"<CR>', opts)
keymap("", "<Down>", ':echoerr "nono don be stopid"<CR>', opts)
keymap("", "<Left>", ':echoerr "nono don be stopid"<CR>', opts)
keymap("", "<Right>", ':echoerr "nono don be stopid"<CR>', opts)

keymap("i", "<Up>", "<Nop>", opts)
keymap("i", "<Down>", "<Nop>", opts)
keymap("i", "<Left>", "<Nop>", opts)
keymap("i", "<Right>", "<Nop>", opts)

-- Navigate buffers
keymap("n", "<Tab>", ":bnext<CR>", opts)
keymap("n", "<S-Tab>", ":bprevious<CR>", opts)

-- Close buffers
keymap("n", "<S-q>", "<cmd>bdelete!<CR>", opts)

-- Stay in indent mode when indenting
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Copy to clipboard
keymap("n", "cy", functions.YankFixedCursor(""), opts)
keymap("n", "cyy", functions.YankFixedCursor("_"), opts)
keymap("x", "Y", function()
	functions.SendToClip(vim.fn.visualmode(), 1)
end, opts)

-- " Paste from "0 register by default unless a register other than the default is specified.
-- " From: https://stackoverflow.com/questions/18391573/how-make-vim-paste-to-always-paste-from-register-0-unless-its-specified
keymap({ "n", "x" }, "p", function()
	functions.FormatPaste(vim.v.register, "p")
end, opts)
keymap({ "n", "x" }, "P", function()
	functions.FormatPaste(vim.v.register, "P")
end, opts)

-- Paste from clipboard
keymap({ "n", "x" }, "cp", function()
	functions.FormatPaste("+", "p")
end, opts)
keymap({ "n", "x" }, "cP", function()
	functions.FormatPaste("+", "P")
end, opts)

-- Select most recent pasted text
keymap("n", "gV", function()
	return "`[" .. vim.fn.getregtype(vim.v.register):sub(1, 1) .. "`]"
end, optsExpr)

-- Toggle spell check.
keymap("n", "<F5>", ":setlocal spell!<CR>", opts)
keymap("i", "<F5>", "<C-o>:setlocal spell!<CR>", opts)

-- Line text-objects
keymap("x", "il", "g_o^o")
keymap("o", "il", ":<C-u>exe 'normal v' . v:count1 . 'il'<CR>", opts)
keymap("x", "al", "g_o0o")
keymap("o", "al", ":<C-u>exe 'normal v' . v:count1 . 'al'<CR>", opts)

-- Action: Show treesitter capture group for textobject under cursor.
-- keymap("n", "<C-e>",
--     function()
--         local result = vim.treesitter.get_captures_at_cursor(0)
--         print(vim.inspect(result))
--     end,
--     { noremap = true, silent = false }
-- )

-- Diagnostics
keymap(
	"n",
	"<M-CR>",
	":lua vim.diagnostic.open_float()<CR>",
	{ noremap = true, silent = true, desc = "Open Diagnostics Floating Window" }
)
keymap(
	"n",
	"]d",
	":lua vim.diagnostic.goto_next()<CR>",
	{ noremap = true, silent = true, desc = "Go to next Diagnostic" }
)
keymap(
	"n",
	"[d",
	":lua vim.diagnostic.goto_prev()<CR>",
	{ noremap = true, silent = true, desc = "Go to prev Diagnostic" }
)

------ Plugin Mappings ------
-- nvim-notify
keymap("n", "<leader>nc", function()
	require("notify").dismiss({ silent = true })
end, opts)

-- LuaSnips
-- Snippet expansion key.
-- Press Ctrl-k to either expand the current item, or jump to the next item.
keymap({ "i", "s" }, "<C-k>", function()
	if require("luasnip").expand_or_jumpable() then
		require("luasnip").expand_or_jump()
	end
end, opts)
-- Press Ctrl-j to jump backwards in the snippet.
keymap({ "i", "s" }, "<C-j>", function()
	if require("luasnip").jumpable(-1) then
		require("luasnip").jump(-1)
	end
end, opts)
-- Press Ctrl-h Ctrl-l to select within a list of options. Useful for choice nodes.
keymap("i", "<C-l>", function()
	if require("luasnip").choice_active() then
		require("luasnip").change_choice(1)
	end
end)
keymap("i", "<C-h>", function()
	if require("luasnip").choice_active() then
		require("luasnip").change_choice(-1)
	end
end)

-- Lsp_Lines
keymap("", "<Leader><leader>l", function()
	require("lsp_lines").toggle()
end, { desc = "Toggle lsp_lines" })

-- Harpoon
keymap("n", "<leader>ha", function()
	require("harpoon.mark").add_file()
end, opts)
keymap("n", "<leader>hh", function()
	require("harpoon.ui").toggle_quick_menu()
end, opts)
keymap("n", "<M-h>", function()
	require("harpoon.ui").nav_file(1)
end, opts)
keymap("n", "<M-j>", function()
	require("harpoon.ui").nav_file(2)
end, opts)
keymap("n", "<M-k>", function()
	require("harpoon.ui").nav_file(3)
end, opts)
keymap("n", "<M-l>", function()
	require("harpoon.ui").nav_file(4)
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
	require("fzf-lua").files()
end, opts)
keymap("n", "<leader>l", function()
	require("fzf-lua").blines()
end, opts)
keymap("n", "<leader>b", function()
	if vim.v.count ~= 0 then
		-- vim.cmd("buf " .. vim.v.count)
		vim.cmd("LualineBuffersJump " .. vim.v.count)
	else
		require("fzf-lua").buffers()
	end
end, opts)
keymap("n", "<leader>?", function()
	require("fzf-lua").help_tags()
end, opts)
keymap("n", "<leader>/", function()
	require("fzf-lua").grep_curbuf()
end, opts)
keymap("n", "<leader><C-_>", function() -- <C-_> is CTRL-/
	require("fzf-lua").grep_project()
end, opts)
keymap("n", "<leader>t", function()
	require("fzf-lua").tags()
end, opts)
keymap("n", "<leader>m", function()
	require("fzf-lua").marks()
end, opts)
