return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"FelipeLema/cmp-async-path", -- Complete filepaths
			"hrsh7th/cmp-buffer", -- Word completion in current buffer
			"hrsh7th/cmp-calc", -- Math completion
			"saadparwaiz1/cmp_luasnip", -- Luasnip completion
			"hrsh7th/cmp-nvim-lsp", -- LSP completions
			"hrsh7th/cmp-nvim-lua", -- Lua completions
			"onsails/lspkind.nvim", -- VSCode-like pictograms in lsp completion menu
		},
		event = "InsertEnter",
		init = function()
			vim.opt.completeopt = { "menu", "menuone", "noselect" }
		end,
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
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
					["<C-Space>"] = cmp.mapping.complete(),
				}),
				sources = {
					{ name = "luasnip" },
					{ name = "nvim_lsp" },
					{ name = "nvim_lua" },
					{ name = "async_path" },
					{ name = "calc" },
					{ name = "buffer", max_item_count = 6 },
				},
				formatting = {
					format = require("lspkind").cmp_format({
						mode = "symbol_text", -- show only symbol annotations
						preset = "codicons",
						maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
						ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
						menu = {
							buffer = "[Buf]",
							nvim_lsp = "[LSP]",
							luasnip = "[LuaSnip]",
							nvim_lua = "[Lua]",
							path = "[Path]",
							latex_symbols = "[Latex]",
						},
					}),
				},
				experimental = {
					native_menu = false,
					ghost_text = true,
				},
			})

			-- LspKind highlights
			vim.api.nvim_set_hl(0, "CmpItemMenu", { link = "NonText" })
		end,
	},
}
