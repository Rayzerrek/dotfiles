require('nvim-treesitter').setup({})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('MinimalTreesitter', { clear = true }),
  pattern = { 'python', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'json', 'jsonc', 'css', 'html', 'lua', 'bash', 'sh', 'markdown' },
  callback = function(ev)
    if vim.b[ev.buf].large_file then return end
    local ok = pcall(vim.treesitter.start, ev.buf)
    if ok then vim.bo[ev.buf].syntax = '' end
  end,
})
