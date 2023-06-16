return {
	-- mason.nvim
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		cmd = "Mason",
		opts = {
			ui = {
				icons = {
					package_installed = "",
					package_pending = "",
					package_uninstalled = "",
				},
			},
		},
	},

	-- lspconfig
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			{
				"williamboman/mason-lspconfig.nvim",
				opts = {
					ensure_installed = {
						"lua_ls",
						"clangd",
						"neocmake",
						"marksman",
					},
				},
			},
			{
				"jay-babu/mason-null-ls.nvim",
				opts = {
					ensure_installed = {
						"stylua",
						"markdownlint",
						-- 'luacheck',
					},
				},
			},
		},
		event = {
			"BufReadPre",
			"BufNewFile",
		},
		config = function()
			local lspconfig = require("lspconfig")
			-- local keys = {
			-- 	{
			-- 		'gd',
			-- 		function()
			-- 			return require('fzf-lua').lsp_definitions()
			-- 		end,
			-- 		desc = 'Goto Definition',
			-- 	},
			-- 	{
			-- 		'gr',
			-- 		function()
			-- 			return require('fzf-lua').lsp_references()
			-- 		end,
			-- 		desc = 'References',
			-- 	},
			-- 	{
			-- 		'gD',
			-- 		-- vim.lsp.buf.declaration,
			-- 		function()
			-- 			return require('fzf-lua').lsp_declarations()
			-- 		end,
			-- 		desc = 'Goto Declaration',
			-- 	},
			-- 	{
			-- 		'gI',
			-- 		function()
			-- 			return require('fzf-lua').lsp_implementations()
			-- 		end,
			-- 		desc = 'Goto Implementation',
			-- 	},
			-- 	{
			-- 		'gy',
			-- 		function()
			-- 			return require('fzf-lua').lsp_type_definitions()
			-- 		end,
			-- 		desc = 'Goto T[y]pe Definition',
			-- 	},
			-- 	{
			-- 		'K',
			-- 		vim.lsp.buf.hover,
			-- 		desc = 'Hover',
			-- 	},
			-- 	{
			-- 		'gK',
			-- 		vim.lsp.buf.signature_help,
			-- 		desc = 'Signature Help',
			-- 	},
			-- }
			lspconfig.neocmake.setup({
				root_dir = lspconfig.util.root_pattern(
					"CMakePresets.json",
					"CTestConfig.cmake",
					".git",
					"build",
					"cmake"
				),
			})

			lspconfig.clangd.setup({})

			lspconfig.lua_ls.setup({
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = {
								[vim.fn.expand("$VIMRUNTIME/lua")] = true,
								[vim.fn.stdpath("config") .. "/lua"] = true,
							},
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})

			lspconfig.marksman.setup({})

			-- Use LspAttach autocommand to only map the following keys
			-- after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("LspConfig", {}),
				callback = function(ev)
					-- Enable completion triggered by <c-x><c-o>
					-- vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

					-- Buffer local mappings.
					vim.keymap.set("n", "gd", function()
						return require("fzf-lua").lsp_definitions()
					end, { buffer = ev.buf, desc = "Goto Definition" })

					vim.keymap.set("n", "gr", function()
						return require("fzf-lua").lsp_references()
					end, { buffer = ev.buf, desc = "References" })

					vim.keymap.set("n", "gD", function()
						return require("fzf-lua").lsp_declarations()
					end, { buffer = ev.buf, desc = "Goto Declaration" })

					vim.keymap.set("n", "gI", function()
						return require("fzf-lua").lsp_implementations()
					end, { buffer = ev.buf, desc = "Goto Implementation" })

					vim.keymap.set("n", "gy", function()
						return require("fzf-lua").lsp_type_definitions()
					end, { buffer = ev.buf, desc = "Goto T[y]pe Definition" })

					vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover" })
					vim.keymap.set("n", "gk", vim.lsp.buf.signature_help, { buffer = ev.buf, desc = "Signature Help" })
				end,
			})
		end,
	},

	-- null-ls.nvim
	{
		"jose-elias-alvarez/null-ls.nvim",
		dependencies = "williamboman/mason.nvim",
		event = {
			"BufReadPre",
			"BufNewFile",
		},
		opts = function()
			local nls = require("null-ls")
			return {
				sources = {
					nls.builtins.formatting.stylua,
					nls.builtins.formatting.markdownlint,
					-- nls.builtins.diagnostics.markdownlint,
					-- nls.builtins.diagnostics.luacheck,
				},
			}
		end,
	},
}
