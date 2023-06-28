return {
	{
		"gennaro-tedesco/nvim-possession",
		lazy = false,
		dependencies = {
			{
				"tiagovla/scope.nvim",
				lazy = false,
				config = true,
			},
		},
		-- keys = {
		-- 	"<leader>sl",
		-- 	"<leader>sn",
		-- 	"<leader>su",
		-- 	"<leader>sd",
		-- },
		config = function()
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

			require("nvim-possession").setup({
				sessions = {
					sessions_path = vim.g.session_dir,
					sessions_variable = "session",
					sessions_icon = "📌 ",
				},

				autoload = true,
				autoswitch = {
					enable = true,
				},
				save_hook = function()
					vim.cmd([[ScopeSaveState]]) -- Scope.nvim integration
				end,
				post_hook = function()
					vim.cmd([[ScopeLoadState]]) -- Scope.nvim integration
				end,

				fzf_winopts = {
					height = 0.4,
					width = 0.2,
					row = 0.5,
					col = 0.5,
				},
			})
		end,
	},
}
