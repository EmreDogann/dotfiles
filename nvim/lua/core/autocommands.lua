-- Define local variables
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Remove trailing whitespaces
autocmd('BufWritePre', {
    callback = function()
        vim.cmd('%s/\\s\\+$//e')
    end,
})

-- Highlight text on yank
local yankHighlightGroup = augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
    group = yankHighlightGroup,
    callback = function()
        vim.highlight.on_yank { higroup = 'IncSearch', timeout = '300' }
    end,
})

-- Turn off search highlighting when exiting search field
local searchHighlightGroup = augroup('incsearchHighlight', {clear = true})
autocmd('CmdlineEnter', {
	group = searchHighlightGroup,
	pattern = {
		'/',
		'?'
	},
	callback = function()
		vim.opt.hlsearch = true
	end
})
autocmd('CmdlineLeave', {
	group = searchHighlightGroup,
	pattern = {
		'/',
		'?'
	},
	callback = function()
		vim.opt.hlsearch = false
	end
})

-- Automatically rebalance windows on vim resize
autocmd('VimResized', {
    callback = function()
        vim.cmd('tabdo wincmd =')
    end,
})

-- Never insert line as a comment when using 'o' to enter insert mode
autocmd('BufWinEnter', {
    callback = function()
        vim.cmd('setlocal formatoptions-=cro')
    end,
})

-- Close man and help with just <q>
autocmd('FileType', {
    pattern = {
        'help',
        'man',
        'lspinfo',
        'checkhealth',
		'netrw',
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
    end,
})

-- Check for spelling in text filetypes and enable wrapping
autocmd('FileType', {
    pattern = { 'gitcommit', 'markdown' },
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.wrap = true
    end,
})

-- Check if the file needs to be reloaded when it's changed
autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
    command = 'silent! checktime'
})
