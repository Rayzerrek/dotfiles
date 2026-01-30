vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
-- === Plugins ===
require("lazy").setup(require("plugins"), {})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "rust", "go" },
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
})


vim.opt.smartindent = true
vim.opt.shiftwidth = 2

vim.opt.breakindent = true

vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.termguicolors = true
vim.opt.shortmess:append("I")
vim.opt.laststatus = 2
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.hidden = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.errorbells = true
vim.opt.visualbell = true
vim.opt.showmatch = false
vim.opt.showmode = false
vim.opt.mouse:append("a")
vim.opt.listchars = { tab = "› ", eol = "¬", trail = "⋅" }
vim.opt.langmenu = "en"
vim.env.LANG = "en"
vim.opt.shellquote = "\""
vim.opt.shellxquote = ""
vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true
vim.o.background = "dark"

vim.opt.shell = "C:\\msys64\\usr\\bin\\zsh.exe"
vim.opt.shellcmdflag = "-c"
vim.opt.shellquote = ""
vim.opt.shellxquote = ""

vim.diagnostic.config({
  float = { border = "rounded" },
  -- virtual_text = { current_line = true },
  virtual_lines = false,
})


local map = vim.keymap.set
local opts = { noremap = true, silent = true }


map("n", "<Leader><Tab>", ":bnext<CR>", opts)
map("n", "<Leader><S-Tab>", ":bprev<CR>", opts)

map("n", "<Leader>y", '"+y', opts)
map("n", "<Leader>p", '"+p', opts)

map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)
map("n", "<C-h>", "<C-w>h", opts)

map("n", "S", ":%s//g<Left><Left>", { noremap = true })
map("n", "Q", "<Nop>", { noremap = true })
map("n", "<Leader>n", function()
  require("oil").toggle_float()
end, { desc = "Toggle oil file explorer" }

)

-- Telescope
local telescope = require("telescope")
telescope.setup({
  defaults = {
    layout_config = { prompt_position = "top" },
    sorting_strategy = "ascending",
    file_ignore_patterns = { "node_modules", "%.git", "target" },
  },
})
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)
map("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", opts)
map("n", "<leader>fc", "<cmd>Telescope commands<cr>", opts)
map("n", "<leader>fr", "<cmd>Telescope registers<cr>", opts)



-- local statusline_parts = {
--   "%<",
--   " %{mode()} ",
--   " | ",
--   " %f%m ",
--   " | ",
--   "%{&paste?'PASTE':''} ",
--   "%= ",
--   " | ",
--   "%{&filetype}",
--   " | ",
--   "%l/%L(%c)",
-- }
--
-- vim.opt.statusline = table.concat(statusline_parts, "")

vim.g.vim_markdown_conceal = 0
vim.g.vim_markdown_conceal_code_blocks = 0
vim.g.vim_json_conceal = 0
vim.g.indentLine_fileTypeExclude = { "markdown", "md" }
vim.g.markdown_fenced_languages = { "python", "js=javascript", "ruby", "ts=typescript" }

-- Rainbow parentheses
vim.g["rainbow#pairs"] = { { "(", ")" }, { "[", "]" }, { "{", "}" } }

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.exists(":NoMatchParen") == 2 then
      vim.cmd("NoMatchParen")
    end
  end,
})
