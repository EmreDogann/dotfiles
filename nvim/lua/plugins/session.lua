return {
	"gennaro-tedesco/nvim-possession",
	dependencies = { "ibhagwan/fzf-lua" },
	config = function()
		require("nvim-possession").setup({
			autoload = true,
			autoswitch = {
				enable = true,
			},
			fzf_winopts = {
				height = 0.4,
				width = 0.2,
				row = 0.5,
				col = 0.5,
			},
		})

		vim.keymap.set("n", "<leader>sl", function()
			require("nvim-possession").list()
		end, { silent = true })
		vim.keymap.set("n", "<leader>sn", function()
			require("nvim-possession").new()
		end, { silent = true })
		vim.keymap.set("n", "<leader>su", function()
			require("nvim-possession").update()
		end, { silent = true })
		vim.keymap.set("n", "<leader>sd", function()
			require("nvim-possession").delete()
		end, { silent = true })
	end,
}
