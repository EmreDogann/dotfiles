local g = vim.g
local o = vim.o
local opt = vim.opt
local wo = vim.wo
local bo = vim.bo
local uname = vim.loop.os_uname()
local os = uname.sysname

vim.g.IS_MAC = os == "Darwin"
vim.g.IS_LINUX = os == "Linux"
vim.g.IS_WINDOWS = os:find("Windows") and true or false
vim.g.IS_WSL = vim.g.IS_LINUX and uname.release:lower():find("microsoft") and true or false
vim.g.session_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/")

o.fileencoding = "utf-8"
-- vim.o.clipboard = 'unnamedplus'

-- Set directory for swap & backup files.
o.directory = vim.env.MYNEOVIMDIR .. "/swap//"
o.shada = "!,f1,'100,<100,s10,h,n" .. vim.env.MYNEOVIMDIR .. "/shada"
o.viewdir = vim.env.MYNEOVIMDIR .. "/view//"
o.backupdir = vim.env.MYNEOVIMDIR .. "/backup//"
o.undodir = vim.env.MYNEOVIMDIR .. "/undo//"
o.spellfile = vim.env.MYNEOVIMDIR .. "/spell/en.utf-8.add"

-- Change grepprg to use ripgrep.
if vim.fn.executable("rg") == 1 then
	o.grepprg = "rg --vimgrep --smart-case --hidden"
	o.grepformat = "%f:%l:%m,%f:%l%m,%f  %l%m"
end

-- Spelling Language
o.spelllang = "en_us"
opt.spellsuggest:append("10")

-- Configure timeout duration
o.ttimeout = true
o.timeoutlen = 1000
o.ttimeoutlen = 10 -- Under 10 causes cursor glitching when exiting insert mode.
o.ttyfast = true

-- Searching
o.incsearch = true -- Highlight matching characters as you search
o.ignorecase = true -- Ignore captial letters during search
o.smartcase = true -- Override the ignorecase option if searching for capital letters
o.hlsearch = true -- Highlight during a search.
vim.fn.setreg("/", "") -- Reset search highlighting on lua config load
o.history = 1000 -- Command history size
o.showcmd = true -- Show the partial command you type in the last line of the screen
-- o.showcmdloc = "statusline" -- Will show the partial command somewhere else when cmdheight = 0.

-- Completion
o.wildmenu = true -- Enable auto completion command menu with <Tab>
opt.wildmode = "full" -- wildmenu behaves like bash completion
opt.wildignore = {
	"*.swp",
	"*.bak",
	"*.docx",
	"*.jpg",
	"*.png",
	"*.gif",
	"*.pdf",
	"*.pyc",
	"*.exe",
	"*.flv",
	"*.img",
	"*.xlsx",
	"*/.git/**/*",
	"*/.hg/**/*",
	"*/.svn/**/*",
}
o.wildignorecase = true -- Case insensitive tab completion

-- Session & View
opt.sessionoptions:append("globals")
opt.sessionoptions:append("winpos")
opt.sessionoptions:remove("options")
opt.sessionoptions:remove("terminal")

-- Indent guides
-- opt.list = true
-- opt.listchars = { tab = "\\u258f ", trail = '·', extends = '»', precedes = '«', nbsp = '×' }

opt.shortmess:append("c")

o.backup = true -- Enable backups
o.undofile = true -- Enable undo file
o.cmdheight = 0 -- Give more space for displaying messages
o.updatetime = 300 -- Faster completion (4000ms default)
o.signcolumn = "yes" -- Always show sign column
vim.cmd("filetype plugin indent on") -- filetype detection[ON] plugin[ON] indent[ON]
opt.complete:append("kspell") -- Keyword completion. kSpell - dictionary

o.backspace = "indent,eol,start"
o.mouse = "a" -- Enable mouse in all modes
o.startofline = false -- Disable moving cursor to first non-blank char in line after commands.
o.cursorline = true -- Highlight cursor line underneath the cursor.

-- Tab config
o.shiftwidth = 4 -- Number of spaces to use for each stop of (auto)indent
o.shiftround = true -- Round indent to multiple of 'shiftwidth'
o.tabstop = 4 -- Number of spaces a <Tab> counts for
o.softtabstop = 4 -- Number of spaces a <Tab> counts for while editing.
o.autoindent = true -- Keep indentation from previous line
o.smartindent = true -- Auto inserts indentation in some cases
o.breakindent = true
o.smarttab = true

o.scrolloff = 6 -- Minimal number of screen lines to keep above and below the cursor
o.sidescrolloff = 6 -- Minimal number of screen columns to keep to the left and right of the cursor
o.wrap = false -- Do not wrap lines

-- Folding
-- o.foldmethod = "manual"
-- o.foldmethod = "expr"
-- o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
o.foldenable = true
o.foldlevelstart = 99 -- Start with all folds open initially
o.foldlevel = 99

o.hidden = true -- Keep changes to bugger without writing them to the file
o.autowrite = true -- Auto save changes made to the buffer
-- o.lazyredraw = true			-- Don't redraw screen immediately
o.splitbelow = true -- Open split to right and bottom.
o.splitright = true
o.splitkeep = "screen"
o.pumblend = 20 -- Popup Menu background transparency blending
o.winblend = 20 -- FLoating window background transparency blending
o.pumheight = 10 -- Make popup menu smaller
o.laststatus = 2 -- Always show statusline
o.showtabline = 2 -- Always show tabline
o.termguicolors = true -- Set term gui colors (most terminals support this)
-- o.colorcolumn = "80" -- Show column where taxt wrapping occurs
-- opt.isekyword:append("-")	-- treats words with `-` as single words

-- Status Column
o.number = true -- Add line numbers.
o.relativenumber = true -- Change line numbers to relative line numbers.
wo.foldcolumn = "1"
wo.numberwidth = 3
vim.o.fillchars = [[fold: ,foldopen:,foldsep: ,foldclose:]]
-- wo.signcolumn = "yes:1"
-- wo.signcolumn = "number"

-- Netrw options
g.netrw_keepdir = 0
g.netrw_liststyle = 3
g.netrw_banner = 0
g.netrw_winsize = 25
g.netrw_browse_split = 4
g.netrw_altv = 1
g.netrw_list_hide = opt.wildignore

-- Disable provider warnings in the healthcheck
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
