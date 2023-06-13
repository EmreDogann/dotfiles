local functions = require('functions')

return {
	{'tpope/vim-surround'},
	{'tpope/vim-commentary'},
	{'tpope/vim-fugitive'},
	{'tommcdo/vim-exchange'},
	{'junegunn/vim-peekaboo'},
	-- {'dstein64/vim-startuptime'},
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
		init = function()
			vim.g.move_key_modifier = "S"
			vim.g.move_key_modifier_visualmode = "S"
		end
	},
	{
		'tmsvg/pear-tree',
		init = function()
			vim.g.pear_tree_smart_openers = 1
			vim.g.pear_tree_smart_closers = 1
			vim.g.pear_tree_smart_backspace = 1
		end
	},
	{
		'unblevable/quick-scope',
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
	-- {
	-- 	'norcalli/nvim-colorizer.lua',
	-- 	event = "VeryLazy",
	-- 	init = function()
	-- 		-- Attaches to every FileType mode
	-- 		require('colorizer').setup()
	-- 	end
	-- },
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
