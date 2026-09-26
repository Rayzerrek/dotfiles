-- Autocommands

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local mitchell_group = augroup("MitchellConfig", { clear = true })

-- Automatically strip trailing whitespace on save
autocmd("BufWritePre", {
  group = mitchell_group,
  pattern = "*",
  command = "%s/\\s\\+$//e",
})

-- Default open folds
autocmd("BufWinEnter", {
  group = mitchell_group,
  pattern = "*",
  command = "set foldlevel=999999",
})

-- Vagrantfile filetype detection
autocmd({ "BufRead", "BufNewFile" }, {
  group = mitchell_group,
  pattern = "Vagrantfile",
  command = "set filetype=ruby",
})

-- HCL filetype detection
autocmd({ "BufRead", "BufNewFile" }, {
  group = mitchell_group,
  pattern = { "*.hcl", "*.nomad", "*.tf", "*.tfvars" },
  command = "set filetype=hcl",
})

-- Bats filetype detection (as sh)
autocmd({ "BufRead", "BufNewFile" }, {
  group = mitchell_group,
  pattern = "*.bats",
  command = "set filetype=sh",
})

-- AsciiDoc filetype detection
autocmd({ "BufRead", "BufNewFile" }, {
  group = mitchell_group,
  pattern = { "*.asciidoc", "*.adoc" },
  command = "set filetype=asciidoc",
})

-- Language specific tab/indent settings
autocmd("FileType", {
  group = mitchell_group,
  pattern = "go",
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = false
  end,
})

autocmd("FileType", {
  group = mitchell_group,
  pattern = "zig",
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = true
  end,
})

autocmd("FileType", {
  group = mitchell_group,
  pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact", "json", "yaml", "ruby", "sh", "lua" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})