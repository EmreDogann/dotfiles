local foldIcon = ""
local hlgroup = "NonText"
local function foldTextFormatter(virtText, lnum, endLnum, width, truncate)
	local newVirtText = {}
	local suffix = "  " .. foldIcon .. "  " .. tostring(endLnum - lnum)
	local sufWidth = vim.fn.strdisplaywidth(suffix)
	local targetWidth = width - sufWidth
	local curWidth = 0
	for _, chunk in ipairs(virtText) do
		local chunkText = chunk[1]
		local chunkWidth = vim.fn.strdisplaywidth(chunkText)
		if targetWidth > curWidth + chunkWidth then
			table.insert(newVirtText, chunk)
		else
			chunkText = truncate(chunkText, targetWidth - curWidth)
			local hlGroup = chunk[2]
			table.insert(newVirtText, { chunkText, hlGroup })
			chunkWidth = vim.fn.strdisplaywidth(chunkText)
			if curWidth + chunkWidth < targetWidth then
				suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
			end
			break
		end
		curWidth = curWidth + chunkWidth
	end
	table.insert(newVirtText, { suffix, hlgroup })
	return newVirtText
end

return {
	{
		"luukvbaal/statuscol.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local builtin = require("statuscol.builtin")
			require("statuscol").setup({
				relculright = true,
				segments = {
					{
						text = { builtin.foldfunc, " " },
						condition = { true, builtin.not_empty },
						-- click = "v:lua.ScFa",
					},
					{
						text = { builtin.lnumfunc, " " },
						condition = { true, builtin.not_empty },
						-- click = "v:lua.ScLa",
					},
					{
						text = { "%s" },
						condition = { true, builtin.not_empty },
						-- click = "v:lua.ScSa",
					},
				},
				-- segments = {
				--   { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
				--   {
				--     sign = { name = { "Diagnostic" }, maxwidth = 2, auto = true },
				--     click = "v:lua.ScSa"
				--   },
				--   { text = { builtin.lnumfunc }, click = "v:lua.ScLa", },
				--   {
				--     sign = { name = { ".*" }, maxwidth = 2, colwidth = 1, auto = true, wrap = true },
				--     click = "v:lua.ScSa"
				--   },
				-- }
			})
		end,
	},

	-- Code Folding
	{
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		event = "BufReadPost",
		keys = {
			{
				"zR",
				function()
					return require("ufo").openAllFolds()
				end,
				desc = "Open all folds",
			},
			{
				"zM",
				function()
					return require("ufo").closeAllFolds()
				end,
				desc = "Close all folds",
			},
		},
		config = function()
			require("ufo").setup({
				provider_selector = function(bufnr, filetype, buftype)
					local lspWithOutFolding = { "markdown", "bash", "sh", "bash", "zsh", "css" }
					if vim.tbl_contains(lspWithOutFolding, filetype) then
						return { "treesitter", "indent" }
					else
						return { "lsp", "indent" }
					end
				end,
				close_fold_kinds = { "imports" },
				fold_virt_text_handler = foldTextFormatter,
			})
		end,
	},
}
