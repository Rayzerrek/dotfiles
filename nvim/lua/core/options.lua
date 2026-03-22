vim.g.mapleader = " "

local opt = vim.opt
local g = vim.g
local env = vim.env

opt.smartindent = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.expandtab = true
opt.breakindent = true
opt.backspace = { "indent", "eol", "start" }

opt.number = true
opt.relativenumber = false

opt.termguicolors = true
opt.background = "dark"

opt.shortmess:append("I")
opt.laststatus = 2
opt.splitright = true
opt.splitbelow = true
opt.hidden = true
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.errorbells = true
opt.visualbell = true
opt.showmatch = false
opt.showmode = false
opt.mouse:append("a")
opt.clipboard = "unnamedplus"
opt.cursorline = true

opt.listchars = { tab = "› ", eol = "¬", trail = "⋅" }

opt.langmenu = "en"
env.LANG = "en"

opt.shell = "pwsh"
opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
opt.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
opt.shellquote = ""
opt.shellxquote = ""

g.vim_markdown_conceal = 0
g.vim_markdown_conceal_code_blocks = 0
g.vim_json_conceal = 0
g.indentLine_fileTypeExclude = { "markdown", "md" }
g.markdown_fenced_languages = { "python", "js=javascript", "ruby", "ts=typescript" }
g["rainbow#pairs"] = { { "(", ")" }, { "[", "]" }, { "{", "}" } }

vim.diagnostic.config({
  float = { border = "rounded" },
  virtual_lines = false,
})
