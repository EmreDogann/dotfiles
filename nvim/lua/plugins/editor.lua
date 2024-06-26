local foldIcon = ""
local hlgroup = "NonText"
local function foldTextFormatter(virtText, lnum, endLnum, width, truncate)
	local newVirtText = {}
	local suffix = "  " .. foldIcon .. "  " .. tostring(endLnum - lnum)
	local sufWidth = vim.fn.strdisplaywidth(suffix)
	local targetWidth = width - sufWidth
	local curWidth = 0
	for _, chunk in ipairs(virtText) do
		local chunkText = chunk[1]
		local chunkWidth = vim.fn.strdisplaywidth(chunkText)
		if targetWidth > curWidth + chunkWidth then
			table.insert(newVirtText, chunk)
		else
			chunkText = truncate(chunkText, targetWidth - curWidth)
			local hlGroup = chunk[2]
			table.insert(newVirtText, { chunkText, hlGroup })
			chunkWidth = vim.fn.strdisplaywidth(chunkText)
			if curWidth + chunkWidth < targetWidth then
				suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
			end
			break
		end
		curWidth = curWidth + chunkWidth
	end
	table.insert(newVirtText, { suffix, hlgroup })
	return newVirtText
end

-- nvim-hlslens & nvim-ufo integration
local function nN(char)
	local ok, winid = require("hlslens").nNPeekWithUFO(char)
	if ok and winid then
		-- Safe to override buffer scope keymaps remapped by ufo,
		-- ufo will restore previous buffer keymaps before closing preview window
		-- Type <CR> will switch to preview window and fire `trace` action
		vim.keymap.set("n", "<CR>", function()
			local keyCodes = vim.api.nvim_replace_termcodes("<Tab><CR>", true, false, true)
			vim.api.nvim_feedkeys(keyCodes, "im", false)
		end, { buffer = true, silent = true })
	end
end

return {
	{
		"luukvbaal/statuscol.nvim",
		event = { "BufReadPre", "BufNewFile", "TabLeave" },
		config = function()
			local builtin = require("statuscol.builtin")
			require("statuscol").setup({
				relculright = true,
				segments = {
					-- {
					-- 	text = { builtin.foldfunc, " " },
					-- 	condition = { true, builtin.not_empty },
					-- 	-- click = "v:lua.ScFa",
					-- },
					{
						text = { " " },
						condition = { true, builtin.not_empty },
					},
					{
						condition = { true, builtin.not_empty },
						click = "v:lua.ScSa",
						sign = {
							name = { "Dap*" },
							maxwidth = 1,
							colwidth = 2,
							auto = true,
							fillchar = " ",
						},
					},
					{
						condition = { true, builtin.not_empty },
						-- click = "v:lua.ScSa",
						sign = {
							name = { "Diagnostic*" },
						},
					},
					{
						text = { builtin.lnumfunc, " " },
						condition = { true, builtin.not_empty },
						-- click = "v:lua.ScLa",
					},
					{
						-- text = { "%#SignColumn#▏" },
						click = "v:lua.ScSa",
						condition = { true, builtin.not_empty },
						sign = {
							name = { "GitSign*" }, -- table of lua patterns to match the sign name against
							-- namespace = { "gitsign*" }, -- table of lua patterns to match the extmark sign namespace against
							-- maxwidth = 2,
							colwidth = 2,
						},
					},
				},
			})
		end,
	},

	-- Gitsigns
	{
		"lewis6991/gitsigns.nvim",
		lazy = false,
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "│" },
					change = { text = "│" },
					delete = { text = "│" },
					topdelete = { text = "│" },
					changedelete = { text = "│" },
					untracked = { text = "┆" },
				},
				signcolumn = true,
				preview_config = {
					border = "single",
					style = "minimal",
					relative = "cursor",
					row = 0,
					col = 1,
				},
			})
		end,
	},

	-- Code Folding
	{
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		event = { "BufReadPost", "BufNewFile" },
		keys = {
			{
				"zR",
				function()
					return require("ufo").openAllFolds()
				end,
				desc = "Open all folds",
			},
			{
				"zM",
				function()
					return require("ufo").closeAllFolds()
				end,
				desc = "Close all folds",
			},
		},
		config = function()
			require("ufo").setup({
				provider_selector = function(bufnr, filetype, buftype)
					local lspWithOutFolding = { "markdown", "bash", "sh", "bash", "zsh", "css" }
					if vim.tbl_contains(lspWithOutFolding, filetype) then
						return { "treesitter", "indent" }
					else
						return { "lsp", "indent" }
					end
				end,
				close_fold_kinds = { "imports" },
				fold_virt_text_handler = foldTextFormatter,
			})
		end,
	},

	-- nvim-hlslens
	{
		"kevinhwang91/nvim-hlslens",
		keys = {
			{
				"n",
				[[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
				noremap = true,
				silent = true,
				mode = { "n", "x" },
			},
			{
				"N",
				[[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
				noremap = true,
				silent = true,
				mode = { "n", "x" },
			},
			{ "/", [[/<Cmd>lua require('hlslens').start()<CR>]], noremap = true, silent = true, mode = { "n", "x" } },
			{ "?", [[?<Cmd>lua require('hlslens').start()<CR>]], noremap = true, silent = true, mode = { "n", "x" } },
			{ "*", [[*<Cmd>lua require('hlslens').start()<CR>]], noremap = true, silent = true, mode = { "n", "x" } },
			{ "#", [[#<Cmd>lua require('hlslens').start()<CR>]], noremap = true, silent = true, mode = { "n", "x" } },
			{
				"g*",
				[[g*<Cmd>lua require('hlslens').start()<CR>]],
				noremap = true,
				silent = true,
				mode = { "n", "x" },
			},
			{
				"g#",
				[[g#<Cmd>lua require('hlslens').start()<CR>]],
				noremap = true,
				silent = true,
				mode = { "n", "x" },
			},
		},
		config = function()
			require("hlslens").setup({
				calm_down = true,
				nearest_only = true,
				nearest_float_when = "auto",
			})

			local opts = { noremap = true, silent = true }

			vim.keymap.set({ "n", "x" }, "n", function()
				nN("n")
				vim.cmd([[normal! zz]])
			end, opts)
			vim.keymap.set({ "n", "x" }, "N", function()
				nN("N")
				vim.cmd([[normal! zz]])
			end, opts)
		end,
	},

	-- bufdelete.nvim
	{
		"famiu/bufdelete.nvim",
		keys = {
			{
				"<leader>q",
				function()
					return require("bufdelete").bufdelete(0, false)
				end,
				desc = "Delete the current buffer, but keep split.",
			},
			-- {
			-- 	"<leader>bK",
			-- 	function()
			-- 		return require("bufdelete").bufdelete(0, true)
			-- 	end,
			-- 	desc = "Delete the current buffer forcefully",
			-- },
		},
	},

	{
		"akinsho/toggleterm.nvim",
		keys = {
			"<C-\\>",
		},
		cmd = {
			"ToggleTerm",
			"ToggleTermToggleAll",
			"TermExec",
			"TermSelect",
			"ToggleTermSendCurrentLine",
			"ToggleTermSendVisualLines",
			"ToggleTermSendVisualSelection",
			"ToggleTermSetName",
		},
		version = "*",
		config = function()
			require("toggleterm").setup({
				open_mapping = [[<c-\>]],
				size = 20,
				hide_numbers = true,
				shade_ftletypes = {},
				shade_terminals = true,
				shading_factor = 2,
				start_in_insert = true,
				insert_mapptngs = true,
				persist_size = true,
				direction = "horizontal",
				close_on_exit = true,
				shell = vim.o.shell,
			})

			function _G.set_terminal_keymaps()
				local opts = { buffer = 0 }
				vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
				vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
				vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
				vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
				vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
			end

			-- if you only want these mappings for toggle term use term://*toggleterm#* instead
			vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
		end,
	},
}
