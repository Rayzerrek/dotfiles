vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.title = true
vim.opt.titlestring = "nvim - %t"

if vim.fn.has('wsl') == 1 and vim.fn.executable('win32yank.exe') == 1 then
  vim.g.clipboard = 'win32yank'
end

local opt = vim.opt
opt.clipboard = 'unnamedplus'
opt.number = true
opt.termguicolors = true
opt.signcolumn = 'yes'
opt.laststatus = 3
opt.showmode = false
opt.ignorecase = true
opt.smartcase = true
opt.splitbelow = true
opt.splitright = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.scrolloff = 4
opt.updatetime = 250
opt.timeoutlen = 400
opt.undofile = true
opt.completeopt = { 'menu', 'menuone', 'noselect' }
opt.synmaxcol = 300


local group = vim.api.nvim_create_augroup('MinimalConfig', { clear = true })
vim.api.nvim_create_autocmd('BufReadPre', {
  group = group,
  callback = function(ev)
    local stat = vim.uv.fs_stat(ev.file)
    vim.b[ev.buf].large_file = stat ~= nil and stat.size > 1024 * 1024
  end,
})
vim.api.nvim_create_autocmd('BufReadPost', {
  group = group,
  callback = function(ev)
    if vim.api.nvim_buf_line_count(ev.buf) > 20000 then
      vim.b[ev.buf].large_file = true
    end
    if vim.b[ev.buf].large_file then
      vim.bo[ev.buf].syntax = 'OFF'
    end
  end,
})
vim.api.nvim_create_autocmd('FileType', {
  group = group,
  pattern = 'python',
  callback = function(ev)
    vim.bo[ev.buf].shiftwidth = 4
    vim.bo[ev.buf].tabstop = 4
  end,
})
vim.api.nvim_create_autocmd('TextYankPost', {
  group = group,
  callback = function() vim.hl.on_yank({ timeout = 120 }) end,
})

vim.pack.add({
  'https://github.com/navarasu/onedark.nvim',
  'https://github.com/nvim-lualine/lualine.nvim',
  { src = 'https://github.com/Saghen/blink.cmp', version = vim.version.range('1') },
  'https://github.com/stevearc/oil.nvim',
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  'https://github.com/stevearc/conform.nvim',
}, { confirm = false })

require('onedark').setup({ style = 'dark' })
require('onedark').load()
require('lualine').setup({
  options = {
    theme = 'onedark',
    icons_enabled = false,
    component_separators = '|',
    section_separators = '',
    globalstatus = true,
    refresh = { statusline = 1000 },
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diagnostics' },
    lualine_c = { { 'filename', path = 1 } },
    lualine_x = { 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
})
require('oil').setup({
  columns = {},
  skip_confirm_for_simple_edits = false,
  watch_for_changes = false,
  view_options = { show_hidden = true },
})
require('blink.cmp').setup({
  enabled = function() return not vim.b.large_file end,
  keymap = {
    preset = 'default',
    ['<Tab>'] = { 'select_and_accept', 'snippet_forward', 'fallback' },
  },
  fuzzy = { implementation = 'prefer_rust_with_warning' },
  sources = { default = { 'lsp', 'path', 'snippets' } },
  completion = {
    list = { selection = { preselect = false, auto_insert = false } },
    documentation = { auto_show = true, auto_show_delay_ms = 300 },
    menu = { draw = { columns = { { 'label', 'label_description', gap = 1 }, { 'kind' } } } },
  },
  cmdline = { enabled = false },
  signature = { enabled = false },
})

require('config.lsp')
require('config.syntax')
vim.api.nvim_create_autocmd('FileType', {
  group = group,
  pattern = { 'python', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'json', 'jsonc', 'css' },
  once = true,
  callback = function() require('config.format') end,
})

local map = vim.keymap.set
map('n', '-', '<Cmd>Oil<CR>', { desc = 'Files: parent directory' })
map('n', '<leader>w', '<Cmd>write<CR>', { desc = 'Save' })
map('n', '<leader>f', function()
  require('config.format')
  require('conform').format({ async = true, lsp_format = 'never' })
end, { desc = 'Format' })
map('n', '<leader>tf', function()
  vim.b.autoformat_disabled = not vim.b.autoformat_disabled
  vim.notify('Format on save: ' .. (vim.b.autoformat_disabled and 'off' or 'on'))
end, { desc = 'Toggle format on save (buffer)' })
local line_diagnostics_win
map('n', '<leader>e', function()
  if line_diagnostics_win and vim.api.nvim_win_is_valid(line_diagnostics_win) then
    vim.api.nvim_win_close(line_diagnostics_win, true)
    line_diagnostics_win = nil
    return
  end
  local _, win = vim.diagnostic.open_float(0, { scope = 'line', focus = false })
  line_diagnostics_win = win
end, { desc = 'Toggle line diagnostics' })
local diagnostics_win
map('n', '<leader>d', function()
  if diagnostics_win and vim.api.nvim_win_is_valid(diagnostics_win) then
    vim.api.nvim_win_close(diagnostics_win, true)
    diagnostics_win = nil
    return
  end
  local _, win = vim.diagnostic.open_float(0, {
    scope = 'buffer',
    focus = false,
    border = 'rounded',
    header = 'Diagnostyki pliku',
    source = true,
    max_width = math.max(20, math.floor(vim.o.columns * 0.8)),
    max_height = math.max(1, math.floor(vim.o.lines * 0.6)),
    prefix = function(diagnostic)
      return string.format('%d:%d: ', diagnostic.lnum + 1, diagnostic.col + 1)
    end,
  })
  diagnostics_win = win
  if not win then vim.notify('Brak diagnostyk w tym pliku') end
end, { desc = 'Toggle file diagnostics (floating window)' })
map('n', '<Esc>', '<Cmd>nohlsearch<CR>')
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')
