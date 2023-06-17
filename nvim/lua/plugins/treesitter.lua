return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
        {
            'nvim-treesitter/nvim-treesitter-context',
			config = true
		},
	},
	build = ':TSUpdate',
	event = {
		'BufReadPost',
		'BufNewFile'
	},
	config = function()
		require('nvim-treesitter.configs').setup({
			-- A list of parser names, or "all" (the five listed parsers should always be installed)
			ensure_installed = {
				'lua',
				'luadoc',
				'luap',
				'cpp',
				'markdown',
				'markdown_inline',
				'git_config',
				'git_rebase',
				'gitcommit',
				'gitignore',
				'gitattributes',
				'diff',
				'vim',
				'vimdoc',
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
				additional_vim_regex_highlighting = false
			},
			matchup = {
				enable = true
			},
			indent = {
				enable = true
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "gnn", -- set to `false` to disable one of the mappings
					node_incremental = "grn",
					scope_incremental = "grc",
					node_decremental = "grm"
				}
			}
		})
	end
}