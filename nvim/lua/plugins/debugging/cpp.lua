local file = require("utils.file")
local dap = require("dap")

dap.defaults.fallback.terminal_win_cmd = "10split new"

dap.configurations.cpp = {
	{
		name = "C++ Debug And Run",
		type = "codelldb",
		request = "launch",
		program = function()
			-- First, check if exists CMakeLists.txt
			local cwd = vim.fn.getcwd()
			return vim.fn.input("Path to executable: ", cwd .. "/", "file")

			-- if file.exists(cwd, "CMakeLists.txt") then
			-- 	-- Then invoke cmake commands
			-- 	-- Then ask user to provide execute file
			-- 	return vim.fn.input("Path to executable: ", cwd .. "/", "file")
			-- else
			-- 	local fileName = vim.fn.expand("%:t:r")
			-- 	-- create this directory
			-- 	os.execute("mkdir -p " .. "bin")
			-- 	local cmd = "!g++ -g % -o bin/" .. fileName
			-- 	-- First, compile it
			-- 	vim.cmd(cmd)
			-- 	-- Then, return it
			-- 	return "${fileDirname}/bin/" .. fileName
			-- end
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		runInTerminal = true,
		console = "integratedTerminal",
	},

	{
		-- If you get an "Operation not permitted" error using this, try disabling YAMA:
		--  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
		name = "Attach to process",
		type = "cpp", -- Adjust this to match your adapter name (`dap.adapters.<name>`)
		request = "attach",
		pid = require("dap.utils").pick_process,
		args = {},
	},
}
