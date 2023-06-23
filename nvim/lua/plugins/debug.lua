local keymap = vim.keymap.set
local keymap_restore = {}

-- Global keymaps for nvim-dap
keymap({ "n", "t" }, "<F5>", function()
	require("dap").continue()
end, { silent = true, desc = "Debug: Continue" })
keymap("n", "<leader>db", function()
	require("dap").toggle_breakpoint()
end, { silent = true, desc = "Debug: Toggle breakpoint" })
keymap(
	"n",
	"<leader>dB",
	"<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
	{ silent = true, desc = "Debug: Toggle Conditional Breakpoint" }
)
keymap("n", "<C-p><C-b>", function()
	require("fzf-lua").dap_breakpoints()
end, { silent = true, desc = "Debug: List breakpoints (Fzf-Lua)" })

return {
	-- Auto-install debuggers
	{
		"jay-babu/mason-nvim-dap.nvim",
		opts = {
			ensure_installed = {
				"codelldb",
			},
			automatic_installation = false,
		},
	},

	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"jay-babu/mason-nvim-dap.nvim",
			"theHamsta/nvim-dap-virtual-text",
			"rcarriga/nvim-dap-ui",
		},
		config = function()
			local dap = require("dap")
			local dap_virtual_text = require("nvim-dap-virtual-text")
			local dap_ui = require("dapui")

			dap_virtual_text.setup({
				enabled = true, -- enable this plugin (the default)
				enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
				highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
				highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
				show_stop_reason = true, -- show stop reason when stopped for exceptions
				commented = true, -- prefix virtual text with comment string
				only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
				all_references = false, -- show virtual text on all all references of the variable (not only definitions)
				filter_references_pattern = "<module", -- filter references (not definitions) pattern when all_references is activated (Lua gmatch pattern, default filters out Python modules)
				-- experimental features:
				virt_text_pos = "eol", -- position of virtual text, see `:h nvim_buf_set_extmark()`
				all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
				virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
				virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
				-- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
			})

			dap_ui.setup()
			-- dap_ui.setup({
			-- 	layouts = {
			-- 		{
			-- 			-- elements = {
			-- 			-- 	"watches",
			-- 			-- },
			-- 			size = 0.2,
			-- 			position = "left",
			-- 		},
			-- 	},
			-- 	controls = {
			-- 		enabled = false,
			-- 	},
			-- 	render = {
			-- 		max_value_lines = 3,
			-- 	},
			-- 	floating = {
			-- 		max_height = nil, -- These can be integers or a float between 0 and 1.
			-- 		max_width = nil, -- Floats will be treated as percentage of your screen.
			-- 		border = "single", -- Border style. Can be "single", "double" or "rounded"
			-- 		mappings = {
			-- 			close = { "q", "<Esc>" },
			-- 		},
			-- 	},
			-- })

			local icons = require("utils.icons")
			vim.api.nvim_set_hl(0, "DapStoppedLinehl", { bg = "#555530" })
			vim.fn.sign_define(
				"DapBreakpoint",
				{ text = icons.ui.TinyCircle, texthl = "Error", linehl = "", numhl = "" }
			)
			vim.fn.sign_define(
				"DapBreakpointCondition",
				{ text = icons.ui.CircleWithGap, texthl = "Error", linehl = "", numhl = "" }
			)
			vim.fn.sign_define(
				"DapLogPoint",
				{ text = icons.ui.LogPoint, texthl = "DapLogPoint", linehl = "", numhl = "" }
			)
			vim.fn.sign_define(
				"DapStopped",
				{ text = icons.ui.Amogus, texthl = "Error", linehl = "DapStoppedLinehl", numhl = "" }
			)
			vim.fn.sign_define(
				"DapBreakpointRejected",
				{ text = icons.diagnostics.Error, texthl = "Error", linehl = "", numhl = "" }
			)

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dap_ui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dap_ui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dap_ui.close()
			end

			require("plugins.debugging.adapters.lldb")
			require("plugins.debugging.cpp")

			-- You can reuse configurations for other languages
			-- dap.configurations.c = dap.configurations.cpp
			-- dap.configurations.rust = dap.configurations.cpp

			-- Key: keymap to set
			-- Value: {mode(s), command/function, opts}
			-- local keysToSet = {
			-- 	["K"] = { "n", '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { silent = true } },
			-- }
			--
			-- local api = vim.api
			-- dap.listeners.after["event_initialized"]["me"] = function()
			-- 	for _, buf in pairs(api.nvim_list_bufs()) do
			-- 		local keymaps = api.nvim_buf_get_keymap(buf, "n")
			-- 		for _, val in pairs(keymaps) do
			-- 			if keysToSet[val.lhs] ~= nil then
			-- 				table.insert(keymap_restore, val)
			-- 				api.nvim_buf_del_keymap(buf, "n", val.lhs)
			-- 			end
			-- 		end
			-- 	end
			--
			-- 	for k, v in pairs(keysToSet) do
			-- 		print(v[1], v[2], v[3])
			-- 		api.nvim_set_keymap(v[1], k, v[2], v[3])
			-- 	end
			-- end
			--
			-- dap.listeners.after["event_terminated"]["me"] = function()
			-- 	for _, val in pairs(keymap_restore) do
			-- 		api.nvim_buf_set_keymap(val.buffer, val.mode, val.lhs, val.rhs, { silent = val.silent == 1 })
			-- 	end
			-- 	keymap_restore = {}
			-- end

			keymap({ "n", "t" }, "<A-o>", function()
				require("dap").step_over()
			end, { silent = true, desc = "Debug: Step over" })
			keymap({ "n", "t" }, "<A-O>", function()
				require("dap").step_out()
			end, { silent = true, desc = "Debug: Step out" })
			keymap({ "n", "t" }, "<A-i>", function()
				require("dap").step_into()
			end, { silent = true, desc = "Debug: Step into" })
			keymap({ "n", "t" }, "<leader>dK", function()
				require("dap.ui.widgets").hover()
			end, { silent = true, desc = "Debug: Calculate expr" })

			keymap("n", "<leader>dk", "<cmd>lua require'dap'.up()<CR>", { desc = "Debug: Stack up" })
			keymap("n", "<leader>dj", "<cmd>lua require'dap'.down()<CR>", { desc = "Debug: Stack down" })
			keymap("n", "<leader>dn", "<cmd>lua require'dap'.run_to_cursor()<CR>", { desc = "Debug: Run Until Cursor" })
			keymap("n", "<leader>dq", "<cmd>lua require'dap'.terminate()<CR>", { desc = "Debug: Terminate" })
		end,
	},
}
