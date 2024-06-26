local keymap = vim.keymap.set

return {
	"Civitasv/cmake-tools.nvim",
	cmd = {
		"CMakeGenerate",
		"CmakeBuild",
		"CmakeRun",
		"CMakeDebug",
		"CMakeLaunchArgs",
		"CMakeSelectBuildType",
		"CMakeSelectBuildTarget",
		"CMakeSelectLaunchTarget",
		"CMakeSelectKit",
		"CMakeSelectConfigurePreset",
		"CMakeSelectBuildPreset",
		"CMakeOpen",
		"CMakeClose",
		"CMakeInstall",
		"CMakeClean",
		"CMakeStop",
		"CMakeQuickBuild",
		"CMakeQuickRun",
		"CMakeQuickDebug",
	},
	config = function()
		require("cmake-tools").setup({
			cmake_command = "cmake", -- this is used to specify cmake command path
			cmake_regenerate_on_save = false, -- auto generate when save CMakeLists.txt
			cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" }, -- this will be passed when invoke `CMakeGenerate`
			cmake_build_options = {}, -- this will be passed when invoke `CMakeBuild`
			cmake_build_directory = "", -- this is used to specify generate directory for cmake
			cmake_build_directory_prefix = "build/", -- when cmake_build_directory is set to "", this option will be activated
			cmake_soft_link_compile_commands = true, -- this will automatically make a soft link from compile commands file to project root dir
			cmake_compile_commands_from_lsp = false, -- this will automatically set compile commands file location using lsp, to use it, please set `cmake_soft_link_compile_commands` to false
			cmake_kits_path = nil, -- this is used to specify global cmake kits path, see CMakeKits for detailed usage
			cmake_variants_message = {
				short = { show = true }, -- whether to show short message
				long = { show = true, max_length = 40 }, -- whether to show long message
			},
			cmake_dap_configuration = { -- debug settings for cmake
				name = "cpp",
				type = "codelldb",
				request = "launch",
				stopOnEntry = false,
				runInTerminal = true,
				console = "integratedTerminal",
			},
			cmake_always_use_terminal = false, -- if true, use terminal for generate, build, clean, install, run, etc, except for debug, else only use terminal for run, use quickfix for others
			cmake_quickfix_opts = { -- quickfix settings for cmake, quickfix will be used when `cmake_always_use_terminal` is false
				show = "always", -- "always", "only_on_error"
				position = "belowright", -- "bottom", "top"
				size = 10,
			},
			cmake_terminal_opts = { -- terminal settings for cmake, terminal will be used for run when `cmake_always_use_terminal` is false or true, will be used for all tasks except for debug when `cmake_always_use_terminal` is true
				name = "Main Terminal",
				prefix_name = "[CMakeTools]: ", -- This must be included and must be unique, otherwise the terminals will not work. Do not use a simple spacebar " ", or any generic name
				split_direction = "horizontal", -- "horizontal", "vertical"
				split_size = 11,

				-- Window handling
				single_terminal_per_instance = true, -- Single viewport, multiple windows
				single_terminal_per_tab = true, -- Single viewport per tab
				keep_terminal_static_location = true, -- Static location of the viewport if avialable

				-- Running Tasks
				start_insert_in_launch_task = false, -- If you want to enter terminal with :startinsert upon using :CMakeRun
				start_insert_in_other_tasks = false, -- If you want to enter terminal with :startinsert upon launching all other cmake tasks in the terminal. Generally set as false
				focus_on_main_terminal = false, -- Focus on cmake terminal when cmake task is launched. Only used if cmake_always_use_terminal is true.
				focus_on_launch_terminal = false, -- Focus on cmake launch terminal when executable target in launched.
			},
		})

		keymap("n", "<leader>cg", "<cmd>CMakeGenerate<CR>", { desc = "CMake: Generate" })
		keymap("n", "<leader>cx", "<cmd>CMakeGenerate!<CR>", { desc = "CMake: Clean and generate" })
		keymap("n", "<leader>cbb", "<cmd>CMakeBuild<CR>", { desc = "CMake: Build" })
		keymap("n", "<leader>cll", "<cmd>CMakeRun<CR>", { desc = "CMake: Run" })
		keymap("n", "<leader>cld", "<cmd>CMakeDebug<CR>", { desc = "CMake: Debug" })
		keymap("n", "<leader>cby", "<cmd>CMakeSelectBuildType<CR>", { desc = "CMake: Select Build Type" })
		keymap("n", "<leader>cbt", "<cmd>CMakeSelectBuildTarget<CR>", { desc = "CMake: Select Build Target" })
		keymap("n", "<leader>clt", "<cmd>CMakeSelectLaunchTarget<CR>", { desc = "CMake: Select Launch Target" })
		keymap("n", "<leader>co", "<cmd>CMakeOpen<CR>", { desc = "CMake: Open CMake Console" })
		keymap("n", "<leader>cc", "<cmd>CMakeClose<CR>", { desc = "CMake: Close CMake Console" })
		-- keymap("n", "<leader>ci", "<cmd>CMakeInstall<CR>", { desc = "CMake: Intall CMake target" })
		-- keymap("n", "<leader>cn", "<cmd>CMakeClean<CR>", { desc = "CMake: Clean CMake target" })
		keymap("n", "<leader>cs", "<cmd>CMakeStop<CR>", { desc = "CMake: Stop CMake Process" })
		-- keymap("n", "<leader>cp", "<cmd>cd %:p:h<CR> ", { desc = "CMake: Change pwd to current file" })
	end,
}
