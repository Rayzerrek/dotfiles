require('conform').setup({
  formatters_by_ft = {
    python = { 'ruff_format' },
    javascript = { 'biome' },
    javascriptreact = { 'biome' },
    typescript = { 'biome' },
    typescriptreact = { 'biome' },
    json = { 'biome' },
    jsonc = { 'biome' },
    css = { 'biome' },
  },
  format_on_save = function(bufnr)
    if vim.b[bufnr].large_file or vim.b[bufnr].autoformat_disabled or vim.bo[bufnr].buftype ~= '' then
      return
    end
    return { timeout_ms = 500, lsp_format = 'never' }
  end,
  notify_on_error = true,
})
