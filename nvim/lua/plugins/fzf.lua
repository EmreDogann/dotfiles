return {
	"ibhagwan/fzf-lua",
	event = "VeryLazy",
	module = true,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local actions = require("fzf-lua.actions")
		require("fzf-lua").setup({
			-- "telescope",
			winopts = {
				height = 0.7,
				width = 0.6,
				row = 0.5,
				col = 0.5,
				preview = {
					-- default = 'bat',
					delay = 10,
				},
			},
			actions = {
				files = {
					-- Providers that inherit these actions:
					--   files, git_files, git_status, grep, lsp
					--   oldfiles, quickfix, loclist, tags, btags args
					["default"] = actions.file_edit_or_qf,
					["ctrl-s"] = actions.file_split,
					["ctrl-v"] = actions.file_vsplit,
					["ctrl-t"] = actions.file_tabedit,
					["alt-q"] = actions.file_sel_to_qf,
					["alt-l"] = actions.file_sel_to_ll,
				},
				buffers = {
					-- Providers that inherit these actions:
					--   buffers, tabs, lines, blines
					["default"] = actions.buf_edit,
					["ctrl-s"] = actions.buf_split,
					["ctrl-v"] = actions.buf_vsplit,
					["ctrl-t"] = actions.buf_tabedit,
				},
			},
			fzf_opts = {
				["--info"] = "inline",
				["--padding"] = "3%,3%,3%,3%",
				["--header"] = " ",
				["--no-scrollbar"] = "",
				["--layout"] = "reverse",
			},
			previewers = {
				bat = {
					theme = vim.env.BAT_THEME,
				},
			},
			files = {
				prompt = "File> ",
				-- preview_opts = "hidden",
				cwd_header = false,
				cwd_prompt = false,
				git_icons = false,
				fzf_opts = {
					["--info"] = "inline",
					["--header"] = " ",
					["--no-scrollbar"] = "",
				},
			},
			buffers = {
				-- actions = {
				-- 	["ctrl-d"] = false,
				-- },
				winopts = {
					height = 0.6,
					width = 0.25,
					row = 0.5,
					col = 0.5,
					preview = {
						layout = "vertical",
						vertical = "down:45%",
					},
				},
				fzf_opts = {
					["--padding"] = "5%,3%,5%,3%",
				},
			},
			grep = {
				fzf_opts = {
					["--info"] = "inline",
				},
			},
			lsp = {
				-- make lsp requests synchronous so they work with null-ls
				-- async_or_timeout = 3000,
			},
			file_icon_padding = " ",
		})

		vim.keymap.set("n", "<c-P>", function()
			require("fzf-lua").files()
		end, { silent = true })
		vim.keymap.set("n", "<leader>l", function()
			require("fzf-lua").blines()
		end, { silent = true })
		vim.keymap.set("n", "<leader>b", function()
			if vim.v.count ~= 0 then
				vim.cmd("LualineBuffersJump " .. vim.v.count)
			else
				require("fzf-lua").buffers()
			end
		end, { silent = true })
		vim.keymap.set("n", "<leader>?", function()
			require("fzf-lua").help_tags()
		end, { silent = true })
		vim.keymap.set("n", "<leader>/", function()
			require("fzf-lua").grep_curbuf()
		end, { silent = true })
		vim.keymap.set("n", "<leader><C-_>", function() -- <C-_> is CTRL-/
			require("fzf-lua").grep_project()
		end, { silent = true })
		vim.keymap.set("n", "<leader>t", function()
			require("fzf-lua").tags()
		end, { silent = true })
		vim.keymap.set("n", "<leader>m", function()
			require("fzf-lua").marks()
		end, { silent = true })
	end,
}
