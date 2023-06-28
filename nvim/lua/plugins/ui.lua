return {
	{
		"rcarriga/nvim-notify",
		config = function()
			require("notify").setup({
				-- stages = "fade",
				top_down = true,
				timeout = 3000,
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
					signature = {
						enabled = false, -- Using lsp_signature.nvim instead.
					},
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
				cmdline = {
					view = "cmdline_popup",
					opts = {
						win_options = {
							winblend = 0,
						},
					},
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

	{
		"b0o/incline.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local function get_diagnostic_label(props)
				local diagnosticIconUtil = require("utils.icons").diagnostics_outline
				local icons = {
					error = diagnosticIconUtil.Error,
					warn = diagnosticIconUtil.Warning,
					info = diagnosticIconUtil.Information,
					hint = diagnosticIconUtil.Hint,
				}

				local label = {}
				for severity, icon in pairs(icons) do
					local n =
						#vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
					if n > 0 then
						table.insert(label, { icon .. " " .. n .. " ", group = "DiagnosticSign" .. severity })
					end
				end

				return label
			end

			require("incline").setup({
				debounce_threshold = { rising = 50, falling = 100 },
				window = {
					padding = { left = 0, right = 1 },
					margin = { horizontal = 0, vertical = 0 },
					zindex = 40,
				},
				render = function(props)
					local bufname = vim.api.nvim_buf_get_name(props.buf)
					local filename = (bufname ~= "" and vim.fn.fnamemodify(bufname, ":t") or "[No Name]")
					local diagnostics = get_diagnostic_label(props)
					---@diagnostic disable-next-line: redundant-parameter
					local modified = vim.api.nvim_buf_get_option(props.buf, "modified") and "bold" or "None"
					---@diagnostic disable-next-line: redundant-parameter
					local modified_icon = vim.api.nvim_buf_get_option(props.buf, "modified") and " ● " or " "
					local filetype_icon, color = require("nvim-web-devicons").get_icon_color(filename)

					local is_searching = vim.fn.getcmdtype()
					if is_searching ~= "/" and is_searching ~= "?" then
						is_searching = ""
					end

					local bufferInfo = {
						{ filetype_icon, guifg = color },
						{ " " },
						{ filename, gui = modified },
						{ modified_icon },
					}

					local label = {
						{ " ", guifg = "#8caaee", gui = "None" },
					}

					if #diagnostics > 0 then
						table.insert(diagnostics, { "| ", guifg = "Gray" })
					end

					if props.focused and is_searching ~= "" then
						local count = vim.fn.searchcount({ recompute = 1, maxcount = -1 })
						-- local contents = vim.fn.getcmdline()
						local contents = vim.fn.getcmdline()
						table.insert(label, {
							is_searching .. " ",
							group = "Conceal",
						})
						table.insert(label, {
							(" %s "):format(contents),
							group = "IncSearch",
						})
						table.insert(label, {
							(" %d/%d "):format(count.current, count.total),
							group = "Conceal",
						})
						table.insert(label, { "| ", guifg = "grey" })
					else
						table.insert(label, diagnostics)
					end

					for _, buffer_ in ipairs(bufferInfo) do
						table.insert(label, buffer_)
					end
					return label
				end,
			})
		end,
	},
}
