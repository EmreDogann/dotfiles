return {
	'ibhagwan/fzf-lua',
	event = "VeryLazy",
	module = true,
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	config = function()
		local actions = require("fzf-lua.actions")
		require('fzf-lua').setup({
			"telescope" ,
			winopts = {
				height = 0.7,
				width = 0.6,
				row = 0.5,
				col = 0.5,
				preview = {
					-- default = 'bat',
					delay = 10
				},
			},
			fzf_opts = {
				["--info"] = "inline",
				["--padding"] = "3%,3%,3%,3%",
				["--header"] = " ",
				["--no-scrollbar"] = "",
				["--layout"] = "reverse"
			},
			previewers = {
				bat = {
					theme = vim.env.BAT_THEME
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
				winopts = {
					height = 0.6,
					width = 0.25,
					row = 0.5,
					col = 0.5,
					preview = {
						layout = 'vertical',
						vertical = 'down:45%'
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
			}
		})
	end
}
