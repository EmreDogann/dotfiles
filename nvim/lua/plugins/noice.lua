return {
	{
		"rcarriga/nvim-notify",
		-- module = true,
		-- event = "VeryLazy",
		config = function()
			require("notify").setup({
				-- stages = "fade",
				top_down = true,
				timeout = 2000,
				fps = 60,
			})

			vim.keymap.set("n", "<leader>nc", function()
				require("notify").dismiss({ silent = true })
			end, { silent = true })
		end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = function()
			require("noice").setup({
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
				cmdline = {
					view = "cmdline_popup",
					format = {
						cmdline = { icon = ":" },
					},
				},
				messages = {
					-- view = "mini"
					view_search = false, -- Disable search count messages
				},
				presets = {
					bottom_search = true, -- use a classic bottom cmdline for search
					command_palette = false, -- position the cmdline and popupmenu together
					long_message_to_split = false, -- long messages will be sent to a split
					cmdline_output_to_split = false, -- Show commandline in split window.
					inc_rename = true, -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = true, -- add a border to hover docs and signature help
				},
				views = {
					cmdline_popup = {
						backend = "popup",
						relative = "editor",
						focusable = false,
						enter = false,
						zindex = 60,
						position = {
							row = "95%",
							col = "50%",
						},
						size = {
							min_width = 60,
							width = "auto",
							height = "auto",
						},
						border = {
							style = "rounded",
							padding = { 0, 1 },
						},
						win_options = {
							winhighlight = {
								Normal = "NoiceCmdlinePopup",
								FloatTitle = "NoiceCmdlinePopupTitle",
								FloatBorder = "NoiceCmdlinePopupBorder",
								IncSearch = "",
								CurSearch = "",
								Search = "",
							},
							winbar = "",
							foldenable = false,
							cursorline = false,
						},
					},
					cmdline_popupmenu = {
						view = "popupmenu",
						reverse = true,
						position = {
							row = "90%",
							col = "50%",
						},
						size = {
							width = 60,
							height = 10,
						},
						border = {
							style = "rounded",
							padding = { 0, 1 },
						},
						win_options = {
							winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
						},
					},
					cmdline_output = {
						format = "details",
						view = "split",
					},
					hover = {
						border = {
							padding = { 0, 1 },
						},
					},
					split = {
						enter = true,
						win_options = {
							wrap = false,
						},
					},
				},
				routes = {
					{
						view = "mini",
						filter = {
							any = {
								-- Show all written messages using mini view
								{ event = "msg_show", kind = "", find = "written$" },
								-- Show all undo messages using mini view (https://www.lua.org/pil/20.2.html)
								{ event = "msg_show", kind = "", find = "; %a+ #%d+" },
								-- Show all deletion messages using mini view
								{ event = "msg_show", kind = "", find = "^%d+ fewer lines" },
								-- Show all yanked messages using mini view
								{ event = "msg_show", kind = "", find = "^%d+ lines yanked" },
								-- Show all indented messages using mini view
								{ event = "msg_show", kind = "", find = "^%d+ lines indented" },
							},
						},
					},
					-- Reroute long notifications to splits
					{
						filter = { event = "notify", min_height = 15 },
						view = "split",
					},
					{
						view = "cmdline_output",
						filter = { event = "msg_show", min_height = 20 },
						opts = { format = "details" },
					},
				},
			})
		end,
	},
}
