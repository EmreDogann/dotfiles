return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"FelipeLema/cmp-async-path",	-- Complete filepaths
			"hrsh7th/cmp-buffer",			-- Word completion in current buffer
			"hrsh7th/cmp-calc",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",				-- Snippets
			"saadparwaiz1/cmp_luasnip",		-- Luasnip completion
			"hrsh7th/cmp-nvim-lsp",			-- LSP completions
			"hrsh7th/cmp-nvim-lua",			-- Lua completions
			"onsails/lspkind.nvim",			-- VSCode-like pictograms in lsp completion menu
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				enabled = function()
					-- disable completion in comments
					local context = require("cmp.config.context")
					-- keep command mode completion enabled when cursor is in a comment
					if vim.api.nvim_get_mode().mode == "c" then
						return true
					else
						return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
					end
				end,
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Insert,
						select = true,
					}),
					["<C-Space>"] = cmp.mapping.complete(),
				}),
				sources = {
					{ name = "nvim_lua" },
					{ name = "nvim_lsp" },
					-- { name = 'buffer' },
					{ name = "async_path" },
					-- { name = 'cmdline' },
					{ name = "calc" },
				},
				formatting = {
					format = require("lspkind").cmp_format({
						mode = "symbol_text", -- show only symbol annotations
						preset = "codicons",
						maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
						ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
						menu = {
							buffer = "[Buffer]",
							nvim_lsp = "[LSP]",
							luasnip = "[LuaSnip]",
							nvim_lua = "[Lua]",
							latex_symbols = "[Latex]",
						},

						-- The function below will be called before any actual modifications from lspkind
						-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
						-- before = function (entry, vim_item)
						-- 	...
						-- 	return vim_item
						-- end
					}),
				},
				experimental = {
					ghost_text = true,
				},
			})

			-- LspKind highlights
			vim.api.nvim_set_hl(0, "CmpItemMenu", { link = "NonText" })

			-- -- cmp-cmdline setup
			-- cmp.setup.cmdline('/', {
			-- 	mapping = cmp.mapping.preset.cmdline(),
			-- 	sources = {
			-- 		{ name = 'buffer' },
			-- 	},
			-- })
			--
			-- cmp.setup.cmdline(':', {
			-- 	mapping = cmp.mapping.preset.cmdline(),
			-- 	sources = cmp.config.sources({ { name = 'path' } }, {
			-- 		{
			-- 			name = 'cmdline',
			-- 			option = {
			-- 				ignore_cmds = { 'Man', '!' },
			-- 			},
			-- 		},
			-- 	}),
			-- })
		end,
	},
}
