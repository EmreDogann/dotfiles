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
			"hrsh7th/nvim-cmp",
		},
		event = {
			"BufReadPre",
			"BufNewFile",
		},
		config = function()
			local lspconfig = require("lspconfig")

			-- Add additional capabilities supported by nvim-cmp
			local capabilities = require('cmp_nvim_lsp').default_capabilities()

			lspconfig.neocmake.setup({
				capabilities = capabilities,
				root_dir = lspconfig.util.root_pattern(
					"CMakePresets.json",
					"CTestConfig.cmake",
					".git",
					"build",
					"cmake"
				),
			})

			-- Using clangd-extensions instead. See below.
			-- lspconfig.clangd.setup({})

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
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

			lspconfig.marksman.setup({
				capabilities = capabilities,
			})

			-- Use LspAttach autocommand to only map the following keys
			-- after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("LspConfig", {}),
				callback = function(ev)
					-- Buffer local mappings.
					vim.keymap.set("n", "gd", function()
						return require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
					end, { buffer = ev.buf, desc = "Goto Definition" })

					vim.keymap.set("n", "gr", function()
						return require("fzf-lua").lsp_references({
							jump_to_single_result = true,
							ignore_current_line = true,
						})
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
					vim.keymap.set("n", "gi", "<cmd>ClangdSymbolInfo<CR>", { buffer = ev.buf, desc = "Symbol Info under Cursor" })
					vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename Signature" })
					vim.keymap.set(
						{ "n", "v" },
						"<space>ca",
						vim.lsp.buf.code_action,
						{ buffer = ev.buf, desc = "Perform Code Action" }
					)
				end,
			})
		end,
	},

	-- clangd-extentions
	{
		"p00f/clangd_extensions.nvim",
		dependencies = "hrsh7th/nvim-cmp",
		-- config = function()
		-- 	require("clangd_extensions").setup({
		-- 		server = {
		-- 			capabilities = require('cmp_nvim_lsp').default_capabilities(),
		-- 		}
		-- 	})
		-- end,
		opts = {
			server = {
				capabilities = require('cmp_nvim_lsp').default_capabilities(),
			},
			extensions = {
				autoSetHints = false,
				memory_info = {
					border = "single",
				},
				symbol_info = {
					border = "single",
				},
			}
		}
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
