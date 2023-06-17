
return {
	"L3MON4D3/LuaSnip",
	dependencies = {
		'rafamadriz/friendly-snippets',
	},
	config = function ()
		local luasnip = require('luasnip')
		local types = require('luasnip.util.types')

		-- Load snippet collections
		-- require("luasnip.loaders.from_lua").load({ paths = vim.env.MYNEOVIMDIR .. "/snippets/" })
		require('luasnip.loaders.from_vscode').lazy_load()

		luasnip.setup({
			history = true,
			updateevents = "TextChanged, TextChangedI",
			enable_autosnippets = true,
			ext_opts = {
				[types.choiceNode] = {
					active = {
						virt_text = {{"●", "Error"}},
					}
				}
			}
		})
	end
}
