return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		{
			"nvim-treesitter/nvim-treesitter-context",
			config = true,
		},
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		{
			"RRethy/nvim-treesitter-textsubjects",
		},
	},
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	keys = {
		{ "<F36>", desc = "Increment selection" },
		{ "<F48>", desc = "Decrement selection", mode = "x" },
	},
	config = function()
		require("nvim-treesitter.configs").setup({
			-- A list of parser names, or "all" (the five listed parsers should always be installed)
			ensure_installed = {
				"lua",
				"luadoc",
				"luap",
				"cpp",
				"cmake",
				"markdown",
				"markdown_inline",
				"git_config",
				"git_rebase",
				"gitcommit",
				"gitignore",
				"gitattributes",
				"diff",
				"vim",
				"vimdoc",
				"json",
				"jsonc",
				"rust",
			},

			-- Install parsers synchronously (only applied to `ensure_installed`)
			sync_install = false,

			-- Automatically install missing parsers when entering buffer
			-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
			auto_install = true,

			highlight = {
				enable = true,

				-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
				-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
				-- Using this option may slow down your editor, and you may see some duplicate highlights.
				-- Instead of true it can also be a list of languages
				additional_vim_regex_highlighting = false,
			},
			matchup = {
				enable = true,
			},
			indent = {
				enable = true,
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<CR>",
					scope_incremental = "<CR>",
					node_incremental = "<C-k>",
					node_decremental = "<C-j>",
				},
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
						["ao"] = "@codechunk.outer",
						["io"] = "@codechunk.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						["]m"] = "@function.outer",
						["]c"] = "@codechunk.inner",
						["]]"] = "@class.outer",
					},
					goto_next_end = {
						["]M"] = "@function.outer",
						["]["] = "@class.outer",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						["[c"] = "@codechunk.inner",
						["[["] = "@class.outer",
					},
					goto_previous_end = {
						["[M"] = "@function.outer",
						["[]"] = "@class.outer",
					},
				},
				swap = {
					enable = true,
					swap_next = {
						["]s"] = "@parameter.inner",
					},
					swap_previous = {
						["[s"] = "@parameter.inner",
					},
				},
				lsp_interop = {
					enable = true,
					border = "rounded",
					peek_definition_code = {
						["<leader>kf"] = "@function.outer",
						["<leader>kc"] = "@class.outer",
					},
				},
			},
			-- Currently not working properly with git fugitive.
			-- textsubjects = {
			-- 	enable = true,
			-- 	prev_selection = ",", -- (Optional) keymap to select the previous selection
			-- 	keymaps = {
			-- 		["."] = "textsubjects-smart",
			-- 		[";"] = "textsubjects-container-outer",
			-- 		["i;"] = "textsubjects-container-inner",
			-- 	},
			-- },
		})
	end,
}
