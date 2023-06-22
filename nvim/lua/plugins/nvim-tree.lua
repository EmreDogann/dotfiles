local function my_on_attach(bufnr)
	local api = require("nvim-tree.api")

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	-- default mappings
	api.config.mappings.default_on_attach(bufnr)

	-- custom mappings
	vim.keymap.set("n", "<C-t>", api.tree.change_root_to_parent, opts("Up"))
	vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
	vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
	vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))

	vim.keymap.set("n", "]e", "", { buffer = bufnr })
	vim.keymap.del("n", "[e", { buffer = bufnr })
	vim.keymap.set("n", "]d", api.node.navigate.diagnostics.next, opts("Next Diagnostic"))
	vim.keymap.set("n", "[d", api.node.navigate.diagnostics.prev, opts("Prev Diagnostic"))
end

return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = true,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"antosha417/nvim-lsp-file-operations",
	},
	cmd = {
		"NvimTreeOpen",
		"NvimTreeToggle",
		"NvimTreeFocus",
	},
	keys = {
		{ "<leader>e", ":NvimTreeToggle<CR>", silent = true },
	},
	config = function()
		require("nvim-tree").setup({
			on_attach = my_on_attach,
			disable_netrw = true,
			hijack_cursor = true,
			sync_root_with_cwd = true,
			diagnostics = {
				enable = true,
				show_on_dirs = true,
			},
			renderer = {
				highlight_opened_files = "all",
				highlight_git = true,
				indent_markers = {
					enable = true,
				},
			},
			update_focused_file = {
				enable = true,
				update_root = true,
				ignore_list = {},
			},
			view = {
				width = 35,
				side = "right",
				hide_root_folder = false,
				number = false,
				relativenumber = false,
			},
			modified = {
				enable = true,
				show_on_dirs = true,
				show_on_open_dirs = true,
			},
			git = {
				enable = true,
				ignore = false,
				timeout = 500,
			},
			filters = {
				dotfiles = false,
			},
		})
	end,
}
