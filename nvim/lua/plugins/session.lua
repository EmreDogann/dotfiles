return {
	{
		"gennaro-tedesco/nvim-possession",
		lazy = false,
		dev = true,
		dependencies = {
			"ibhagwan/fzf-lua",
			{
				"tiagovla/scope.nvim",
				dev = true,
				config = function()
					require("scope").setup({
						restore_state = true,
					})
				end,
			},
		},
		-- keys = {
		-- 	"<leader>sl",
		-- 	"<leader>sn",
		-- 	"<leader>su",
		-- 	"<leader>sd",
		-- },
		config = function()
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
				pre_hook = function()
					vim.cmd([[ScopeSaveState]]) -- Scope.nvim integration
				end,
				-- post_hook = function()
				-- 	vim.cmd([[ScopeLoadState]]) -- Scope.nvim integration
				-- end,

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
	},

	-- {
	-- 	"rmagatti/auto-session",
	-- 	lazy = false,
	-- 	event = "VimEnter",
	-- 	config = function()
	-- 		require("auto-session").setup({
	-- 			log_level = "error",
	-- 			auto_save_enabled = true,
	-- 			auto_restore_enabled = true,
	-- 			auto_session_create_enabled = false,
	-- 			auto_session_enable_last_session = false,
	-- 			auto_session_root_dir = vim.g.session_dir,
	-- 			auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
	-- 			cwd_change_handling = {
	-- 				restore_upcoming_session = true, -- already the default, no need to specify like this, only here as an example
	-- 				pre_cwd_changed_hook = nil, -- already the default, no need to specify like this, only here as an example
	-- 				-- post_cwd_changed_hook = function() -- example refreshing the lualine status line _after_ the cwd changes
	-- 				-- 	require("lualine").refresh() -- refresh lualine so the new session name is displayed in the status bar
	-- 				-- end,
	-- 			},
	-- 		})
	-- 	end,
	-- },
}
