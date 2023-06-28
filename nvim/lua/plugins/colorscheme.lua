return {
	"catppuccin/nvim",
	lazy = false,
	priority = 1000,
	name = "catppuccin",
	config = function()
		require("catppuccin").setup({
			flavour = vim.env.THEMEVARIANT, -- latte, frappe, macchiato, mocha
			transparent_background = false, -- disables setting the background color.
			show_end_of_buffer = true, -- shows the '~' characters after the end of buffers
			term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_-1`)
			dim_inactive = {
				enabled = true, -- dims the background color of inactive window
				shade = "dark",
				percentage = 0.25, -- percentage of the shade to apply to the inactive window
			},
			custom_highlight = {
				DiagnosticUnderlineError = { cterm = undercurl, gui = undercurl },
			},
			integrations = {
				which_key = true,
				noice = true,
				notify = true,
				indent_blankline = {
					enabled = true,
					colored_indent_levels = true,
				},
				treesitter = true,
				treesitter_context = true,
				harpoon = true,
				mason = true,
				cmp = true,
				symbols_outline = true,
				dap = {
					enabled = true,
					enable_ui = true, -- enable nvim-dap-ui
				},
				gitsigns = true,
				markdown = true,
				native_lsp = {
					enabled = true,
					virtual_text = {
						errors = { "italic" },
						hints = { "italic" },
						warnings = { "italic" },
						information = { "italic" },
					},
					underlines = {
						errors = { "underline" },
						hints = { "underline" },
						warnings = { "underline" },
						information = { "underline" },
					},
					inlay_hints = {
						background = true,
					},
				},
				nvimtree = true,
			},
		})

		vim.cmd([[colorscheme catppuccin]])

		-- Change vertical split color
		vim.api.nvim_set_hl(0, "VertSplit", { link = "SignColumn" })
		-- vim.api.nvim_set_hl(0, 'Whitespace', {cterm = standout, ctermfg = 240, ctermbg = 235, fg = "#40455d", bg = "#303446"})
		vim.api.nvim_set_hl(0, "Folded", { cterm = reverse, bg = "#3c4052" })
	end,
}
