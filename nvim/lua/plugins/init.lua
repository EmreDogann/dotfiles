local functions = require('functions')

return {
	{'tpope/vim-surround'},
	{'tpope/vim-fugitive'},
	-- {'dstein64/vim-startuptime'},
	-- {'chrisbra/unicode.vim'},
	{ 'tpope/vim-commentary' },
	{
	  'tommcdo/vim-exchange',
	  lazy = true,
	  keys = {'cx'}
	},
	{ 'junegunn/vim-peekaboo' },
	{
		'airblade/vim-rooter',
		init = function()
			-- vim.g.rooter_silent_chdir = 1
			vim.g.rooter_manual_only = 1		-- Start in manual mode
			vim.g.rooter_resolve_links = 1
		end
	},
	{
		'andymass/vim-matchup',
		dependencies = 'nvim-treesitter/nvim-treesitter',
		init = function()
			vim.g.matchup_matchparen_offscreen = { method = 'popup', scrolloff = 1 }
			vim.g.matchup_matchparen_deferred = 1
		end,
		event = {
			'BufReadPost',
			'BufNewFile'
		}
	},
	{
		'matze/vim-move',
		lazy = true,
		keys = {'<S-h>', '<S-j>', '<S-k>', '<S-l>'},
		init = function()
			vim.g.move_key_modifier = "S"
			vim.g.move_key_modifier_visualmode = "S"
		end
	},
	{
		'tmsvg/pear-tree',
		event = "VeryLazy",
		init = function()
			vim.g.pear_tree_smart_openers = 1
			vim.g.pear_tree_smart_closers = 1
			vim.g.pear_tree_smart_backspace = 1
		end
	},
	{
		'unblevable/quick-scope',
		lazy = true,
		keys = {'f', 'F', 't', 'T'},
		init = function()
			vim.g.qs_highlight_on_keys = {'f', 'F', 't', 'T'}
			local qsHighlightGroup = vim.api.nvim_create_augroup('QuickScopeHighlights', {clear = true})
			vim.api.nvim_create_autocmd('ColorScheme', {
				group = qsHighlightGroup,
				callback = function()
					functions.extend_hl('String', 'QuickScopePrimary', {underline = true})
					functions.extend_hl('Error', 'QuickScopeSecondary', {underline = true})
				end
			})

		end
	},

	{'nathom/filetype.nvim'},
	{'nvim-lua/plenary.nvim'},
	{'ThePrimeagen/harpoon'},
	-- {
	-- 	'norcalli/nvim-colorizer.lua',
	-- 	event = "VeryLazy",
	-- 	init = function()
	-- 		-- Attaches to every FileType mode
	-- 		require('colorizer').setup()
	-- 	end
	-- },
	{
		'bennypowers/splitjoin.nvim',
		lazy = true,
		keys = {
			{ 'gj', function() require'splitjoin'.join() end, desc = 'Join the object under cursor' },
			{ 'g,', function() require'splitjoin'.split() end, desc = 'Split the object under cursor' },
		},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event = {
			'BufReadPost',
			'BufNewFile',
		},
		config = function()
			require("indent_blankline").setup({
				use_treesitter = true,
				show_first_indent_level = true,
				show_trailing_blankline_indent = false,
				show_current_context = false,
				-- blankline_char = '│',
				blankline_char = '▏',
				filetype_exclude = {
					'help',
					'NvimTree',
					'dashboard',
					'Trouble',
					'neogitstatus',
				},
				context_patterns = {
					'class',
					'return',
					'function',
					'method',
					'^if',
					'^while',
					'jsx_element',
					'^for',
					'^object',
					'^table',
					'block',
					'arguments',
					'if_statement',
					'else_clause',
					'jsx_element',
					'jsx_self_closing_element',
					'try_statement',
					'catch_clause',
					'import_statement',
					'operation_type',
				},
			})
		end
	},
	{
		'goolord/alpha-nvim',
		event = "VimEnter",
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			require('alpha').setup(require('alpha.themes.startify').config)
		end
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {}
	}
}
