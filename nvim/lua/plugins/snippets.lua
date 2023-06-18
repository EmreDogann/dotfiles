return {
	"L3MON4D3/LuaSnip",
	dependencies = {
		"rafamadriz/friendly-snippets",
	},
	config = function()
		local luasnip = require("luasnip")
		local types = require("luasnip.util.types")

		-- Load snippet collections
		-- require("luasnip.loaders.from_lua").load({ paths = vim.env.MYNEOVIMDIR .. "/snippets/" })
		require("luasnip.loaders.from_vscode").lazy_load()

		luasnip.setup({
			history = true,
			updateevents = "TextChanged, TextChangedI",
			enable_autosnippets = true,
			ext_opts = {
				[types.choiceNode] = {
					active = {
						virt_text = { { "●", "Error" } },
					},
				},
			},
		})

		-- Snippet expansion key.
		-- Press Ctrl-k to either expand the current item, or jump to the next item.
		vim.keymap.set({ "i", "s" }, "<C-k>", function()
			if require("luasnip").expand_or_jumpable() then
				require("luasnip").expand_or_jump()
			end
		end, { silent = true })

		-- Press Ctrl-j to jump backwards in the snippet.
		vim.keymap.set({ "i", "s" }, "<C-j>", function()
			if require("luasnip").jumpable(-1) then
				require("luasnip").jump(-1)
			end
		end, { silent = true })
		-- Press Ctrl-h Ctrl-l to select within a list of options. Useful for choice nodes.
		vim.keymap.set("i", "<C-l>", function()
			if require("luasnip").choice_active() then
				require("luasnip").change_choice(1)
			end
		end, { silent = true })
		vim.keymap.set("i", "<C-h>", function()
			if require("luasnip").choice_active() then
				require("luasnip").change_choice(-1)
			end
		end, { silent = true })
	end,
}
