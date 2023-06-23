local keymap = vim.keymap.set
local opts = { silent = true }
local optsExpr = vim.tbl_extend("force", opts, { expr = true })
local functions = require("functions")

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- Fast quiting
keymap("n", "<S-q>", "<cmd>w<CR><cmd>bd<CR>", { silent = true })

-- Fast saving
keymap("n", "<C-s>", function()
	functions.SaveAll()
end, opts)

---- Auto indent on empty line.
keymap("n", "i", function()
	return string.match(vim.api.nvim_get_current_line(), "%g") == nil and '"_S' or "i"
end, { expr = true, noremap = true })
keymap("n", "I", function()
	return string.match(vim.api.nvim_get_current_line(), "%g") == nil and '"_S' or "I"
end, { expr = true, noremap = true })
keymap("n", "a", function()
	return string.match(vim.api.nvim_get_current_line(), "%g") == nil and '"_S' or "a"
end, { expr = true, noremap = true })
keymap("n", "A", function()
	return string.match(vim.api.nvim_get_current_line(), "%g") == nil and '"_S' or "A"
end, { expr = true, noremap = true })

-- Keep cursor position when joining lines
keymap("n", "J", "mzJ`z", opts)

-- Keep cursor in the middle when scrolling page-up/down or when searching
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)

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

-- Stay in indent mode when indenting
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Copy to clipboard
keymap("n", "<leader>y", functions.YankFixedCursor(""), opts)
keymap("n", "<leader>yy", functions.YankFixedCursor("_"), opts)
keymap("x", "<leader>y", function()
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
keymap({ "n", "x" }, "<leader>p", function()
	functions.FormatPaste("+", "p")
end, opts)
keymap({ "n", "x" }, "<leader>P", function()
	functions.FormatPaste("+", "P")
end, opts)

-- Select most recent pasted text
keymap("n", "gV", function()
	return "`[" .. vim.fn.getregtype(vim.v.register):sub(1, 1) .. "`]"
end, optsExpr)

-- Toggle spell check.
keymap("n", "<F3>", ":setlocal spell!<CR>", opts)
keymap("i", "<F3>", "<C-o>:setlocal spell!<CR>", opts)

-- Line text-objects
keymap("x", "il", "g_o^o")
keymap("o", "il", ":<C-u>exe 'normal v' . v:count1 . 'il'<CR>", opts)
keymap("x", "al", "g_o0o")
keymap("o", "al", ":<C-u>exe 'normal v' . v:count1 . 'al'<CR>", opts)

keymap("n", "<C-CR>", "= print('hey there')<CR>", opts)

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
	"<leader>ca",
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
