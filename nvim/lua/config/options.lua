-- Mitchell Hashimoto's signature options

local opt = vim.opt

-- Leader key
vim.g.mapleader = ";"
vim.g.maplocalleader = ";"

-- Line numbers and cursor
opt.number = true
opt.relativenumber = false
opt.ruler = true
opt.scrolloff = 999 -- Keep cursor vertically centered on the screen
opt.cursorline = true

-- Appearance & Theme
opt.termguicolors = true
opt.colorcolumn = "80"
opt.showmode = true
opt.showmatch = true
opt.title = true
opt.visualbell = true
opt.signcolumn = "yes"

-- Global statusline (from Mitchell's vim-misc.lua: vim.opt.laststatus = 3)
opt.laststatus = 3

-- Invisible characters
opt.list = true
opt.listchars = {
  tab = "› ",
  eol = "¬",
  trail = "⋅",
  nbsp = "␣",
}

-- Indentation & Tabs (4 spaces default, ftplugins customize per language)
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.smartindent = true

-- Search settings
opt.hlsearch = true
opt.ignorecase = true
opt.incsearch = true
opt.smartcase = true

-- Split behavior
opt.splitbelow = true
opt.splitright = true

-- File management & Backups
opt.autoread = true
opt.hidden = true
opt.undofile = true
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.updatetime = 250
opt.timeoutlen = 300

-- Wildmode completion
opt.wildmode = "list:longest"
opt.wildignore:append({ ".git", ".hg", ".svn", "*.6", "*.pyc", "*.rbc", "*.swp", "*.o", "*.obj" })

-- Sessions
opt.sessionoptions = "curdir,folds,help,options,tabpages,winsize"