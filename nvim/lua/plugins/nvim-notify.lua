return {
	'rcarriga/nvim-notify',
	module = true,
	event = "VeryLazy",
	config = function()
		require('notify').setup({
			-- stages = "fade",
			top_down = true,
			timeout = 2000,
			fps = 60,
		})
	end
}
