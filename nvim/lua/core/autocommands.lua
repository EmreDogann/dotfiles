-- Define local variables
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Remove trailing whitespaces
autocmd("BufWritePre", {
	callback = function()
		vim.cmd("%s/\\s\\+$//e")
	end,
})

-- Highlight text on yank
local yankHighlightGroup = augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
	group = yankHighlightGroup,
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = "300" })
	end,
})

-- Turn off search highlighting when exiting search field
local searchHighlightGroup = augroup("incsearchHighlight", { clear = true })
autocmd("CmdlineEnter", {
	group = searchHighlightGroup,
	pattern = {
		"/",
		"?",
	},
	callback = function()
		vim.opt.hlsearch = true
	end,
})
autocmd("CmdlineLeave", {
	group = searchHighlightGroup,
	pattern = {
		"/",
		"?",
	},
	callback = function()
		vim.opt.hlsearch = false
	end,
})

-- Automatically rebalance windows on vim resize
autocmd("VimResized", {
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

-- Never insert line as a comment when using 'o' to enter insert mode
autocmd("BufWinEnter", {
	callback = function()
		vim.cmd("setlocal formatoptions-=cro")
	end,
})

-- Close man and help with just <q>
autocmd("FileType", {
	pattern = {
		"help",
		"man",
		"lspinfo",
		"checkhealth",
		"netrw",
		"noice",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- Disable switching buffers when in Lazy.nvim window.
autocmd("FileType", {
	pattern = { "lazy" },
	callback = function()
		local opts = { silent = true, noremap = false, buffer = true }
		vim.keymap.set("", "<Tab>", "<Nop>", opts)
		vim.keymap.set("", "<S-Tab>", "<Nop>", opts)
		vim.keymap.set("", "<S-Tab>", "<Nop>", opts)
		vim.keymap.set("", "<leader>b", "<Nop>", opts)

		-- Disable Harpoon mappings
		vim.keymap.set("n", "<leader>ha", "<Nop>", opts)
		vim.keymap.set("n", "<leader>hh", "<Nop>", opts)
		vim.keymap.set("n", "<M-h>", "<Nop>", opts)
		vim.keymap.set("n", "<M-j>", "<Nop>", opts)
		vim.keymap.set("n", "<M-k>", "<Nop>", opts)
		vim.keymap.set("n", "<M-l>", "<Nop>", opts)
	end,
})

-- Check for spelling in text filetypes and enable wrapping
autocmd("FileType", {
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.spell = true
		vim.opt_local.wrap = true
	end,
})

-- Check if the file needs to be reloaded when it's changed
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	command = "silent! checktime",
})

local diagnosticsGroup = vim.api.nvim_create_augroup("diagnostics", { clear = true })
vim.api.nvim_create_autocmd("DiagnosticChanged", {
	group = diagnosticsGroup,
	callback = function()
		vim.diagnostic.setloclist({ open = false })
	end,
})

-- -- Show diagnostics under the cursor when holding position
-- vim.api.nvim_create_augroup("lsp_diagnostics_hold", { clear = true })
-- vim.api.nvim_create_autocmd({ "CursorHold" }, {
-- 	pattern = "*",
-- 	callback = function()
-- 		require("functions").OpenDiagnosticIfNoFloat()
-- 	end,
-- 	group = diagnosticsGroup,
-- })
