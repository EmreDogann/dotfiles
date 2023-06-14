return {
	{
		"catppuccin/nvim",
		lazy = false,
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
					percentage = 0.15, -- percentage of the shade to apply to the inactive window
				},
				integrations = {
					which_key = true,
					noice = true,
					notify = true,
					indent_blankline = {
						enabled = true,
						colored_indent_levels = false,
					},
				}
			})

			vim.cmd([[colorscheme catppuccin]])

			-- Change vertical split color
			vim.api.nvim_set_hl(0, 'VertSplit', {link = 'SignColumn'})
			-- vim.api.nvim_set_hl(0, 'Whitespace', {cterm = standout, ctermfg = 240, ctermbg = 235, fg = "#40455d", bg = "#303446"})
			vim.api.nvim_set_hl(0, 'Folded', {cterm = reverse, bg = "#3c4052"})
		end
	}
}
