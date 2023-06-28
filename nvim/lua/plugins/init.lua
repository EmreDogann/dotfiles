local functions = require("functions")

return {
	-- Vim (vimscript) plugins
	-- { "dstein64/vim-startuptime" },
	-- {'chrisbra/unicode.vim'},
	{
		"tpope/vim-fugitive",
		cmd = {
			"Git",
		},
	},
	{
		"tommcdo/vim-exchange",
		keys = { "cx" },
	},
	{
		"junegunn/vim-peekaboo",
		keys = {
			{ '<leader>"', mode = { "n", "x" } },
			{ "<leader>@", mode = { "n", "x" } },
		},
		init = function()
			vim.g.peekaboo_prefix = "<leader>"
			vim.g.peekaboo_ins_prefix = "<C-x>"
		end,
	},
	{
		"andymass/vim-matchup",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = "nvim-treesitter/nvim-treesitter",
		init = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup", scrolloff = 1 }
			vim.g.matchup_matchparen_deferred = 1
		end,
	},
	{
		"matze/vim-move",
		keys = {
			{ "<M-h>", mode = { "n", "x" } },
			{ "<M-j>", mode = { "n", "x" } },
			{ "<M-k>", mode = { "n", "x" } },
			{ "<M-l>", mode = { "n", "x" } },
		},
		init = function()
			vim.g.move_key_modifier = "M"
			vim.g.move_key_modifier_visualmode = "M"
		end,
	},
	{
		"unblevable/quick-scope",
		keys = { "f", "F", "t", "T" },
		init = function()
			vim.g.qs_highlight_on_keys = { "f", "F", "t", "T" }
			local qsHighlightGroup = vim.api.nvim_create_augroup("QuickScopeHighlights", { clear = true })
			vim.api.nvim_create_autocmd("ColorScheme", {
				group = qsHighlightGroup,
				callback = function()
					functions.ExtendHL("String", "QuickScopePrimary", { underline = true })
					functions.ExtendHL("Error", "QuickScopeSecondary", { underline = true })
				end,
			})
		end,
	},

	-- Neovim (lua) plugins
	{
		"nvim-lua/plenary.nvim",
		module = true,
	},
	{
		"nathom/filetype.nvim",
		lazy = false,
	},
	{
		"notjedi/nvim-rooter.lua",
		cmd = {
			"Rooter",
			"RooterToggle",
		},
		config = function()
			require("nvim-rooter").setup({
				rooter_patterns = { ".git", ".hg", ".svn" },
				trigger_patterns = { "*" },
				manual = true,
			})
		end,
	},
	{
		"ThePrimeagen/harpoon",
		init = function()
			vim.keymap.set("n", "<leader>ha", function()
				require("harpoon.mark").add_file()
			end, { silent = true })
			vim.keymap.set("n", "<leader>hh", function()
				require("harpoon.ui").toggle_quick_menu()
			end, { silent = true })
			-- vim.keymap.set("n", "<M-h>", function()
			-- 	require("harpoon.ui").nav_file(1)
			-- end, { silent = true })
			-- vim.keymap.set("n", "<M-j>", function()
			-- 	require("harpoon.ui").nav_file(2)
			-- end, { silent = true })
			-- vim.keymap.set("n", "<M-k>", function()
			-- 	require("harpoon.ui").nav_file(3)
			-- end, { silent = true })
			-- vim.keymap.set("n", "<M-l>", function()
			-- 	require("harpoon.ui").nav_file(4)
			-- end, { silent = true })
		end,
	},
	{ "ThePrimeagen/vim-be-good", cmd = "VimBeGood" },
	{
		"nvim-tree/nvim-web-devicons",
		module = true,
		config = function()
			require("nvim-web-devicons").setup({
				color_icons = true,
			})
		end,
	},
	{
		"gbprod/cutlass.nvim",
		keys = {
			{ "c", mode = { "n", "x" } },
			{ "C", mode = { "n", "x" } },
			{ "s", mode = { "n", "x" } },
			{ "S", mode = { "n", "x" } },
			{ "d", mode = { "n", "x" } },
			{ "D", mode = { "n", "x" } },
			{ "x", mode = { "n", "x" } },
			{ "X", mode = { "n", "x" } },
		},
		config = true,
	},
	{
		"numToStr/Comment.nvim",
		event = "VeryLazy",
		config = true,
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = true,
	},
	{
		"Wansmer/treesj",
		keys = {
			{
				"<leader>j",
				function()
					require("treesj").toggle()
				end,
				desc = "Toggle join/split line under cursor",
			},
		},
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("treesj").setup({
				use_default_keymaps = false,
				max_join_length = 150,
			})
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event = {
			"BufReadPre",
		},
		config = function()
			vim.cmd([[highlight! link IndentBlanklineContextChar Comment]])

			require("indent_blankline").setup({
				use_treesitter = true,
				show_first_indent_level = false,
				show_trailing_blankline_indent = false,
				show_current_context = false,

				-- blankline_char = '│',
				blankline_char = "▏",

				buftype_exclude = { "terminal", "nofile" },
				filetype_exclude = {
					"help",
					"startify",
					"dashboard",
					"packer",
					"neogitstatus",
					"nvimtree",
					"neo-tree",
					"trouble",
				},
			})
		end,
	},
	-- {
	-- 	"goolord/alpha-nvim",
	-- 	event = "VimEnter",
	-- 	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- 	config = function()
	-- 		require("alpha").setup(require("alpha.themes.startify").config)
	-- 	end,
	-- },
	-- Causes <leader>g to move the cursor to the right by 1
	-- {
	-- 	"folke/which-key.nvim",
	-- 	keys = {
	-- 		"<leader>",
	-- 		-- '"',
	-- 		"'",
	-- 		"`",
	-- 		"c",
	-- 		"y",
	-- 		"d",
	-- 		"g",
	-- 	},
	-- 	init = function()
	-- 		vim.o.timeout = true
	-- 		vim.o.timeoutlen = 300
	-- 	end,
	-- 	opts = {
	-- 		window = {
	-- 			border = "single",
	-- 			winblend = 20,
	-- 		},
	-- 	},
	-- },
}
