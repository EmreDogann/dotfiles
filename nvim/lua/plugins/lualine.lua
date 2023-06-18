return {
	"nvim-lualine/lualine.nvim",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		-- "meuter/lualine-so-fancy.nvim",
	},
	config = function()
		require("lualine").setup({
			options = {
				theme = "catppuccin",
				component_separators = "|",
				section_separators = { left = "", right = "" },
			},
			refresh = {
				statusline = 1000,
				tabline = 1000,
				winbar = 1000,
			},
			sections = {
				lualine_a = {
					{ "mode", separator = { left = "" } },
				},
				lualine_b = {
					"branch",
					{
						"diagnostics",
						sources = {
							"nvim_lsp",
							"nvim_diagnostic",
						},
					},
				},
				lualine_c = {
					{
						"filename",
						path = 1,
						newfile_status = true, -- Display new file status (new file means no write after created)
					},
				},
				lualine_x = {
					{
						_G.Statusline_MacroRecording,
						color = { fg = require("catppuccin.palettes").get_palette(vim.env.THEMEVARIANT).red },
					},
					-- {
					-- 	"%S",
					-- 	color = { fg = require("catppuccin.palettes").get_palette(vim.env.THEMEVARIANT).flamingo },
					-- },
					{
						require("noice").api.status.command.get,
						cond = require("noice").api.status.command.has,
						color = { fg = require("catppuccin.palettes").get_palette(vim.env.THEMEVARIANT).flamingo },
					},
				},
				lualine_y = {
					{
						"filetype",
						colored = false,
					},
					{
						"fileformat",
						padding = { left = 1, right = 2 },
						symbols = {
							unix = "", -- e712
							dos = "", -- e70f
							mac = "", -- e711
						},
					},
				},
				lualine_z = {
					{ "location", separator = { right = "" }, left_padding = 2 },
				},
			},
			inactive_sections = {
				lualine_a = {
					{
						"filename",
						padding = { left = 0, right = 5 },
					},
				},
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = { "location" },
			},
			tabline = {
				lualine_a = {
					{
						"buffers",
						icons_enabled = true,
						mode = 2,
						use_mode_colors = true,
					},
				},
				lualine_b = {},
				lualine_c = {},
				lualine_x = {
					{
						_G.Statusline_Getcwd,
						icons_enabled = true,
						icon = "",
					},
					{
						require("nvim-possession").status,
						cond = function()
							return require("nvim-possession").status() ~= nil
						end,
					},
				},
				lualine_y = {},
				lualine_z = {
					{
						"tabs",
						use_mode_colors = true,
					},
				},
			},
			extensions = { "fugitive", "fzf", "lazy", "man", "symbols-outline" },
		})
	end,
}
