return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter-context", config = true },
			{ "nvim-treesitter/nvim-treesitter-textobjects" },
			{ "RRethy/nvim-treesitter-textsubjects" },
			{ "nvim-treesitter/nvim-treesitter-refactor" },
		},
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		keys = {
			{ "<F36>", desc = "Increment selection" },
			{ "<F48>", desc = "Decrement selection", mode = "x" },
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				-- A list of parser names, or "all" (the five listed parsers should always be installed)
				ensure_installed = {
					"lua",
					"luadoc",
					"luap",
					"cpp",
					"cmake",
					"markdown",
					"markdown_inline",
					"git_config",
					"git_rebase",
					"gitcommit",
					"gitignore",
					"gitattributes",
					"diff",
					"vim",
					"vimdoc",
					"json",
					"jsonc",
					"rust",
					"bash",
					"regex",
				},

				-- Install parsers synchronously (only applied to `ensure_installed`)
				sync_install = false,

				-- Automatically install missing parsers when entering buffer
				-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
				auto_install = true,

				highlight = {
					enable = true,

					-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
					-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
					-- Using this option may slow down your editor, and you may see some duplicate highlights.
					-- Instead of true it can also be a list of languages
					additional_vim_regex_highlighting = false,
				},
				matchup = {
					enable = true,
				},
				indent = {
					enable = true,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<CR>",
						scope_incremental = "<CR>",
						node_incremental = "<C-k>",
						node_decremental = "<C-j>",
					},
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
							["ao"] = "@codechunk.outer",
							["io"] = "@codechunk.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]m"] = "@function.outer",
							["]c"] = "@codechunk.inner",
							["]]"] = "@class.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]["] = "@class.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[c"] = "@codechunk.inner",
							["[["] = "@class.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
							["[]"] = "@class.outer",
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["]s"] = "@parameter.inner",
						},
						swap_previous = {
							["[s"] = "@parameter.inner",
						},
					},
					lsp_interop = {
						enable = true,
						border = "rounded",
						peek_definition_code = {
							["<leader>kf"] = "@function.outer",
							["<leader>kc"] = "@class.outer",
						},
					},
				},
				-- Currently not working properly with git fugitive.
				-- textsubjects = {
				-- 	enable = true,
				-- 	prev_selection = ",", -- (Optional) keymap to select the previous selection
				-- 	keymaps = {
				-- 		["."] = "textsubjects-smart",
				-- 		[";"] = "textsubjects-container-outer",
				-- 		["i;"] = "textsubjects-container-inner",
				-- 	},
				-- },
				refactor = {
					highlight_definitions = {
						enable = true,
						clear_on_cursor_move = true,
					},
					smart_rename = {
						enable = true,
						keymaps = {
							-- <F14> is equivalent to <S-F2>
							-- <Fy> where y = x
							-- <S-Fy> where y = x + 12
							-- <C-S-Fy> where y = x + 24 + 12
							-- Tip: In insert mode, press combinations of function keys to get their function codes.
							-- More info:
							--		https://github.com/neovim/neovim/issues/4862#issuecomment-282988543
							--		https://www.reddit.com/r/neovim/comments/1111ixq/there_are_60_f_keys/
							smart_rename = "<F14>",
						},
					},
				},
			})
		end,
	},

	-- nvim-treesitter-cpp-tools
	-- TSCppDefineClassFunc - Implement out of class member functions
	-- subset of functions can be implemented by selecting required function declarations using visual mode or simply keeping the cursor on the function declaration before calling the command
	--
	-- Supported special features
	-- 1. Templates (with default args)
	-- 2. Function arguments with default values
	-- 3. Nested classes
	-- (check test_cases for tested examples)

	-- TSCppMakeConcreteClass - Create a concrete class implementing all the pure virtual functions
	-- TSCppRuleOf3 - Adds the missing function declarations to the class to obey the Rule of 3 (if eligible)
	-- TSCppRuleOf5 - Adds the missing function declarations to the class to obey the Rule of 5 (if eligible)
	{
		"Badhi/nvim-treesitter-cpp-tools",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = function()
			require("nt-cpp-tools").setup({
				preview = {
					quit = "q", -- optional keymapping for quit preview
					accept = "<tab>", -- optional keymapping for accept preview
				},
				header_extension = "h", -- optional
				source_extension = "cxx", -- optional
				custom_define_class_function_commands = { -- optional
					TSCppImplWrite = {
						output_handle = require("nt-cpp-tools.output_handlers").get_add_to_cpp(),
					},
					--[[
					<your impl function custom command name> = {
						output_handle = function (str, context)
							-- string contains the class implementation
							-- do whatever you want to do with it
						end
					}
					]]
				},
			})
		end,
	},
}
