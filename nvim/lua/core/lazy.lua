-- Download Lazy.nvim if nore installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
	defaults = {
		version = false, -- Always use the latest git commit
	},
	ui = {
		border = "single",
		icons = {
			cmd = " ",
			config = " ",
			event = " ",
			ft = " ",
			init = " ",
			import = " ",
			keys = " ",
			lazy = "󰒲 ",
			loaded = "● ",
			not_loaded = "○ ",
			plugin = " ",
			runtime = " ",
			source = " ",
			start = " ",
			task = "✔ ",
			list = {
				"●",
				"➜ ",
				"★ ",
				"‒",
			},
		},
	},
	custom_keys = false,
	checker = { enabled = true },
	change_detection = { notify = false },
	performance = {
		rtp = {
			-- Disable some rtp plugins
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				-- "netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})