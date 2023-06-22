local function GetCapabilities()
	local lspCapabilities = vim.lsp.protocol.make_client_capabilities()
	lspCapabilities.offsetEncoding = { "utf-16" } -- Fixes some weird bugs

	-- Add additional capabilities supported by nvim-cmp
	local cmpCapabilities = require("cmp_nvim_lsp").default_capabilities()
	lspCapabilities = vim.tbl_extend("force", lspCapabilities, cmpCapabilities)

	-- Enable folding (for nvim-ufo)
	lspCapabilities.textDocument.foldingRange = {
		dynamicRegistration = false,
		lineFoldingOnly = true,
	}

	return lspCapabilities
end

return {
	-- mason.nvim
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		cmd = "Mason",
		opts = {
			ui = {
				border = "single",
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
		-- lazy = false,
		-- priority = 999,
		dependencies = {
			"williamboman/mason.nvim",

			-- Auto-install LSP servers
			{
				"williamboman/mason-lspconfig.nvim",
				event = "VeryLazy",
				opts = {
					ensure_installed = {
						"lua_ls",
						"clangd",
						"neocmake",
						"marksman",
					},
					automatic_installation = false,
				},
			},

			-- Auto-install linters/formatters
			{
				"jay-babu/mason-null-ls.nvim",
				opts = {
					ensure_installed = {
						"clang-format",
						"stylua",
						-- "markdownlint",
					},
					automatic_installation = false,
				},
			},

			"folke/neodev.nvim", -- lsp for nvim-lua config
			"p00f/clangd_extensions.nvim", -- Clangd LSP config
			"hrsh7th/nvim-cmp",
		},
		event = {
			"BufReadPre",
			"BufNewFile",
		},
		init = function()
			-- INFO must be before the lsp-config setup of lua-ls
			require("neodev").setup({
				library = { plugins = { "nvim-dap-ui" }, types = true }, -- plugins are helpful e.g. for plenary, but slow down lsp loading
			})

			local lspconfig = require("lspconfig")
			local capabilities = GetCapabilities()

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
						completion = {
							callSnippet = "Replace",
							keywordSnippet = "Replace",
							displayContext = 5,
							postfix = ".", -- useful for `table.insert` and the like
						},
						runtime = {
							-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
							version = "LuaJIT",
						},
						diagnostics = {
							-- Get the language server to recognize the `vim` global
							globals = { "vim" },
						},
						workspace = {
							-- Make the server aware of Neovim runtime files
							-- library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						format = { enable = false }, -- using stylua instead. Also, sumneko-lsp-formatting has this weird bug where all folds are opened
						-- Do not send telemetry data containing a randomized but unique identifier
						telemetry = {
							enable = false,
						},
					},
				},
			})

			lspconfig.marksman.setup({
				capabilities = capabilities,
			})
		end,
		config = function()
			-- Borders
			require("lspconfig.ui.windows").default_options.border = "rounded"
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
			vim.lsp.handlers["textDocument/signatureHelp"] =
				vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

			-- Diagnostic symbols for display in the sign column.
			-- local diagnosticIcons = { Error = "", Warn = "▲", Info = "", Hint = "" }
			local diagnosticIcons = { Error = "🞬", Warn = "▲", Info = "", Hint = "" }
			-- local diagnosticIcons = { Error = "", Warn = "", Info = "", Hint = "" }
			for type, icon in pairs(diagnosticIcons) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end

			local function fmt(diag)
				local source = diag.source and " (" .. diag.source:gsub("%.$", "") .. ")" or ""
				local msg = diag.message
				return msg .. source
			end

			vim.diagnostic.config({
				virtual_text = false,
				virtual_lines = {
					highlight_whole_line = false,
				},
				update_in_insert = false,
				float = {
					header = false,
					format = function(diag)
						return fmt(diag)
					end,
					-- source = "if_many",
					border = "rounded",
					scope = "cursor",
					focusable = false,
					close_events = {
						"CursorMoved",
						"CursorMovedI",
						"BufHidden",
						"InsertCharPre",
						"WinLeave",
					},
				},
				severity_sort = true,
				-- signs = {
				-- 	severity = {
				-- 		min = vim.diagnostic.severity.INFO,
				-- 	},
				-- },
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

					vim.keymap.set("n", "K", function()
						local winid = require("ufo").peekFoldedLinesUnderCursor()
						if not winid then
							vim.lsp.buf.hover()
						end
					end, { buffer = ev.buf, desc = "Hover Symbol or Peek fold" })
					vim.keymap.set("n", "gk", vim.lsp.buf.signature_help, { buffer = ev.buf, desc = "Signature Help" })
					vim.keymap.set(
						"n",
						"gi",
						"<cmd>ClangdSymbolInfo<CR>",
						{ buffer = ev.buf, desc = "Symbol Info under Cursor" }
					)

					-- vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename Signature" })
					vim.keymap.set(
						{ "n", "v" },
						"<M-CR>",
						-- require("fzf-lua").lsp_code_actions,
						"<cmd>CodeActionMenu<CR>",
						-- vim.lsp.buf.code_action,
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
		config = function()
			local capabilities = GetCapabilities()

			require("clangd_extensions").setup({
				server = {
					capabilities = capabilities,
					cmd = {
						"clangd",
						"--background-index",
						"--clang-tidy",
						"--completion-style=detailed",
						"--header-insertion-decorators",
						"--header-insertion=iwyu",
						"--pch-storage=memory",
					},
					init_options = {
						usePlaceholders = true,
						completeUnimported = true,
						clangdFileStatus = true,
					},
					autostart = true,
				},
				extensions = {
					autoSetHints = false,
					memory_info = {
						border = "single",
					},
					symbol_info = {
						border = "single",
					},
				},
			})
		end,
	},

	-- null-ls.nvim
	{
		"jose-elias-alvarez/null-ls.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"nvim-lua/plenary.nvim",
		},
		event = {
			"BufReadPre",
			"BufNewFile",
		},
		config = function()
			local lsp_formatting = function(bufnr)
				vim.lsp.buf.format({
					filter = function(client)
						return client.name == "null-ls"
					end,
					async = false,
					bufnr = bufnr,
				})
			end

			-- If you want to set up formatting on save, you can use this as a callback
			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.clang_format,
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.hover.dictionary.with({ filetypes = { "text", "markdown" } }),
					-- null_ls.builtins.diagnostics.clang_check,
				},
				on_attach = function(client, bufnr) -- Format on save
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								lsp_formatting(bufnr)
							end,
						})
					end
				end,
			})
		end,
	},

	-- lsp_lines.nvim
	{
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		event = "LspAttach",
		config = function()
			require("lsp_lines").setup()
			-- Start off disabled
			require("lsp_lines").toggle()

			vim.keymap.set("", "<F4>", function()
				require("lsp_lines").toggle()
			end, { silent = true, desc = "Toggle lsp_lines" })
		end,
	},

	-- Incremental Rename (like :set incsearch but for LSP renaming)
	{
		"smjonas/inc-rename.nvim",
		keys = {
			{
				"<F2>",
				function()
					return ":IncRename " .. vim.fn.expand("<cword>")
				end,
				expr = true,
				desc = "Rename Signature",
			},
		},
		config = function()
			require("inc_rename").setup()
		end,
	},

	-- symbols-outline.nvim
	-- {
	-- 	"simrat39/symbols-outline.nvim",
	-- 	keys = {
	-- 		{ "<leader>o", "<cmd>SymbolsOutline<CR>", desc = "Open symbols-outline" },
	-- 	},
	-- 	opts = {
	-- 		symbols = {
	-- 			File = { icon = " " },
	-- 			Module = { icon = " " },
	-- 			Namespace = { icon = " " },
	-- 			Package = { icon = " " },
	-- 			Class = { icon = " " },
	-- 			Method = { icon = " " },
	-- 			Property = { icon = " " },
	-- 			Field = { icon = " " },
	-- 			Constructor = { icon = " " },
	-- 			Enum = { icon = " " },
	-- 			Interface = { icon = " " },
	-- 			Function = { icon = " " },
	-- 			Variable = { icon = " " },
	-- 			Constant = { icon = " " },
	-- 			String = { icon = " " },
	-- 			Number = { icon = " " },
	-- 			Boolean = { icon = " " },
	-- 			Array = { icon = " " },
	-- 			Object = { icon = " " },
	-- 			Key = { icon = " " },
	-- 			Null = { icon = " " },
	-- 			EnumMember = { icon = " " },
	-- 			Struct = { icon = " " },
	-- 			Event = { icon = " " },
	-- 			Operator = { icon = " " },
	-- 			TypeParameter = { icon = " " },
	-- 		},
	-- 	},
	-- },
}
