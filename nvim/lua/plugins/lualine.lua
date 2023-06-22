-- Credited to [evil_lualine](https://github.com/nvim-lualine/lualine.nvim/blob/master/examples/evil_lualine.lua)
local conditions = {
	buffer_not_empty = function()
		return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
	end,
	hide_in_width = function()
		return vim.fn.winwidth(0) > 80
	end,
	check_git_workspace = function()
		local filepath = vim.fn.expand("%:p:h")
		local gitdir = vim.fn.finddir(".git", filepath .. ";")
		return gitdir and #gitdir > 0 and #gitdir < #filepath
	end,
}

return {
	"nvim-lualine/lualine.nvim",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		-- "meuter/lualine-so-fancy.nvim",
	},
	config = function()
		local cmake = require("cmake-tools")
		local icons = require("utils.icons")

		require("lualine").setup({
			options = {
				theme = "catppuccin",
				component_separators = "|",
				section_separators = { left = "", right = "" },
				disabled_filetypes = { "lazy", "NvimTree", "peekaboo" },
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
						separator = { right = "" },
					},
					{
						function()
							local cur_buf = vim.api.nvim_get_current_buf()
							return require("hbac.state").is_pinned(cur_buf) and "📍" or ""
							-- tip: nerd fonts have pinned/unpinned icons!
						end,
						padding = {
							left = 0,
							right = 1,
						},
						color = { fg = "#ef5f6b", gui = "bold" },
					},
				},
				lualine_x = {
					{
						_G.Statusline_MacroRecording,
						color = { fg = require("catppuccin.palettes").get_palette(vim.env.THEMEVARIANT).red },
						separator = { right = "" },
					},
					-- {
					-- 	"%S",
					-- 	color = { fg = require("catppuccin.palettes").get_palette(vim.env.THEMEVARIANT).flamingo },
					-- },
					{
						require("noice").api.status.command.get,
						cond = require("noice").api.status.command.has,
						color = { fg = require("catppuccin.palettes").get_palette(vim.env.THEMEVARIANT).flamingo },
						padding = {
							left = 0,
							right = 1,
						},
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
					{
						"location",
						separator = { right = "" },
					},
				},
			},
			inactive_sections = {
				lualine_a = {
					{
						"filename",
						path = 1,
						newfile_status = true, -- Display new file status (new file means no write after created)
						separator = { right = "" },
					},
					{
						function()
							local cur_buf = vim.api.nvim_get_current_buf()
							return require("hbac.state").is_pinned(cur_buf) and "📍" or ""
							-- tip: nerd fonts have pinned/unpinned icons!
						end,
						padding = {
							left = 0,
							right = 1,
						},
						color = { fg = "#ef5f6b", gui = "bold" },
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
						function()
							local type = cmake.get_build_type()
							return "[" .. (type and type or "") .. "]"
						end,
						icon = icons.ui.Gear,
						separator = { right = "" },
						cond = function()
							return cmake.is_cmake_project() and not cmake.has_cmake_preset()
						end,
						on_click = function(n, mouse)
							if n == 1 then
								if mouse == "l" then
									vim.cmd("CMakeSelectBuildType")
								end
							end
						end,
					},
					{
						function()
							return icons.ui.Build
						end,
						separator = { right = "" },
						padding = {
							left = 0,
							right = 1,
						},
						cond = cmake.is_cmake_project,
						on_click = function(n, mouse)
							if n == 1 then
								if mouse == "l" then
									vim.cmd("CMakeBuild")
								end
							end
						end,
					},
					{
						function()
							local b_target = cmake.get_build_target()
							return "[" .. (b_target and b_target or "X") .. "]"
						end,
						separator = { right = "" },
						padding = {
							left = 0,
							right = 1,
						},
						cond = cmake.is_cmake_project,
						on_click = function(n, mouse)
							if n == 1 then
								if mouse == "l" then
									vim.cmd("CMakeSelectBuildTarget")
								end
							end
						end,
					},
					{
						function()
							return icons.ui.Run
						end,
						separator = { right = "" },
						cond = cmake.is_cmake_project,
						on_click = function(n, mouse)
							if n == 1 then
								if mouse == "l" then
									vim.cmd("CMakeRun")
								end
							end
						end,
					},
					{
						function()
							local l_target = cmake.get_launch_target()
							return "[" .. (l_target and l_target or "X") .. "]"
						end,
						padding = {
							left = 0,
							right = 1,
						},
						cond = cmake.is_cmake_project,
						on_click = function(n, mouse)
							if n == 1 then
								if mouse == "l" then
									vim.cmd("CMakeSelectLaunchTarget")
								end
							end
						end,
					},
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
