return {
	'rcarriga/nvim-notify',
	event = "VeryLazy",
	config = function()
		require('notify').setup({
			-- stages = "fade",
			top_down = true,
			timeout = 1000,
			fps = 60,
			background_colour = '#000000'
		})
	end
}
