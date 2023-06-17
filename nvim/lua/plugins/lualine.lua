return {
	"nvim-lualine/lualine.nvim",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				theme = "catppuccin",
				component_separators = "|",
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = {
					{ "mode", separator = { left = "" }, right_padding = 2 },
				},
				lualine_b = {
					"branch",
					"diff",
					{
						"diagnostics",
						sources = {
							-- "nvim_lsp",
							"nvim_diagnostic",
						},
					},
				},
				lualine_c = { "filename" },
				lualine_x = {
					-- {
					-- 	"%S",
					-- 	color = { fg = require("catppuccin.palettes").get_palette(vim.env.THEMEVARIANT).flamingo },
					-- },
					-- {
					-- 	require("noice").api.status.message.get_hl,
					-- 	cond = require("noice").api.status.message.has,
					-- },
					{
						require("noice").api.status.command.get,
						cond = require("noice").api.status.command.has,
						color = { fg = require("catppuccin.palettes").get_palette(vim.env.THEMEVARIANT).flamingo },
					},
					-- {
					-- 	require("noice").api.status.mode.get,
					-- 	cond = require("noice").api.status.mode.has,
					-- 	color = { fg = "#ff9e64" },
					-- },
					-- {
					-- 	require("noice").api.status.search.get,
					-- 	cond = require("noice").api.status.search.has,
					-- 	color = { fg = "#ff9e64" },
					-- },
				},
				lualine_y = {
					{
						"filetype",
						colored = false,
					},
					"fileformat",
				},
				lualine_z = {
					{ "location", separator = { right = "" }, left_padding = 2 },
					-- { require('functions').keymapLualine }
				},
			},
			inactive_sections = {
				lualine_a = { "filename" },
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
				lualine_x = {},
				lualine_y = {},
				lualine_z = { "tabs" },
			},
			extensions = { "fugitive", "fzf", "lazy", "man", "symbols-outline" },
		})
	end,
}