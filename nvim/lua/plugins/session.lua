return {
	"gennaro-tedesco/nvim-possession",
	dependencies = {"ibhagwan/fzf-lua"},
	config = function()
		require('nvim-possession').setup({
			autoload = true,
			autoswitch = {
				enable = true
			},
			fzf_winopts = {
				height = 0.4,
				width = 0.2,
				row = 0.5,
				col = 0.5
			}
		})
	end
}
