local functions = require('functions')

return {
	-- {'dstein64/vim-startuptime'},
	-- {'chrisbra/unicode.vim'},
	{ 'junegunn/vim-peekaboo' },
	{
		'tpope/vim-fugitive',
		cmd = {
			"Git",
		}
	},
	{
	  'tommcdo/vim-exchange',
	  keys = {'cx'}
	},
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
		event = { 'BufReadPost', 'BufNewFile' },
		dependencies = 'nvim-treesitter/nvim-treesitter',
		init = function()
			vim.g.matchup_matchparen_offscreen = { method = 'popup', scrolloff = 1 }
			vim.g.matchup_matchparen_deferred = 1
		end,
	},
	{
		'matze/vim-move',
		keys = {
			{
				'<S-h>',
				mode = {"n", "x"},
			},
			{ '<S-j>', mode = {"n", "x"} },
			{ '<S-k>', mode = {"n", "x"} },
			{ '<S-l>', mode = {"n", "x"} },
		},
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
		'numToStr/Comment.nvim',
		event = "VeryLazy",
		config = true
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end
	},
	{
		'Wansmer/treesj',
		keys = {
			{
				'<leader>j',
				function () vim.keymap.set('n', '<leader>j', require('treesj').toggle) end,
				desc = "Toggle join/split line under cursor"
			},
		},
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
		config = function()
			require('treesj').setup({
				use_default_keymaps = false,
			})
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event = {
			'BufReadPre',
		},
		config = function()
			vim.cmd([[highlight! link IndentBlanklineContextChar Comment]])

			require("indent_blankline").setup({
				use_treesitter = true,
				show_first_indent_level = false,
				show_trailing_blankline_indent = false,
				show_current_context = true,

				-- blankline_char = '│',
				blankline_char = '▏',

				buftype_exclude = { "terminal", "nofile" },
				filetype_exclude = { 'help' },
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
		keys = {
			'<leader>',
			-- '"',
			"'",
			'`',
			'c',
			'y',
			'd',
		},
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			window = {
				border = "single",
				winblend = 20,
			}
		}
	}
}
