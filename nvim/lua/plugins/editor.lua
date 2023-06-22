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
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local builtin = require("statuscol.builtin")
			require("statuscol").setup({
				relculright = true,
				segments = {
					{
						text = { builtin.foldfunc, " " },
						condition = { true, builtin.not_empty },
						-- click = "v:lua.ScFa",
					},
					{
						text = { builtin.lnumfunc, " " },
						condition = { true, builtin.not_empty },
						-- click = "v:lua.ScLa",
					},
					{
						text = { "%s" },
						condition = { true, builtin.not_empty },
						-- click = "v:lua.ScSa",
					},
				},
			})
		end,
	},

	-- Code Folding
	{
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		event = {
			"BufReadPost",
			"BufNewFile",
		},
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
		event = "BufReadPre",
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
				"<S-q>",
				function()
					return require("bufdelete").bufdelete(0, false)
				end,
				desc = "Delete the current buffer",
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
		"axkirillov/hbac.nvim",
		config = function()
			require("hbac").setup({
				autoclose = true, -- set autoclose to false if you want to close manually
				threshold = 7, -- hbac will start closing unedited buffers once that number is reached
				close_command = function(bufnr)
					vim.api.nvim_buf_delete(bufnr, {})
				end,
				close_buffers_with_windows = true, -- hbac will close buffers with associated windows if this option is `true`
			})
		end,
	},

	{
		"weilbith/nvim-code-action-menu",
		-- dev = true,
		cmd = "CodeActionMenu",
		init = function()
			vim.g.code_action_menu_window_border = "rounded"

			vim.g.code_action_menu_show_details = false
			vim.g.code_action_menu_show_diff = true
			vim.g.code_action_menu_show_action_kind = false
		end,
	},
}
