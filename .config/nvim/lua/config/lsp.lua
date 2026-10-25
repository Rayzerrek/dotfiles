local capabilities = require('blink.cmp').get_lsp_capabilities()
local function root(markers)
  return function(bufnr, on_dir)
    if vim.b[bufnr].large_file then return end
    local name = vim.api.nvim_buf_get_name(bufnr)
    if name == '' then return end
    on_dir(vim.fs.root(bufnr, markers) or vim.fs.dirname(name))
  end
end

vim.lsp.config('ts_ls', {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  root_dir = root({ 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' }),
  capabilities = capabilities,
})
vim.lsp.config('pyright', {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_dir = root({ 'pyproject.toml', 'pyrightconfig.json', 'setup.cfg', 'setup.py', '.git' }),
  capabilities = capabilities,
  settings = {
    python = {
      analysis = {
        diagnosticMode = 'openFilesOnly',
        typeCheckingMode = 'basic',
        autoSearchPaths = true,
      },
    },
  },
})
vim.lsp.config('ruff', {
  cmd = { 'ruff', 'server' },
  filetypes = { 'python' },
  root_dir = root({ 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' }),
  capabilities = capabilities,
  on_attach = function(client)
    client.server_capabilities.hoverProvider = false
  end,
})

for name, cmd in pairs({ ts_ls = 'typescript-language-server', pyright = 'pyright-langserver', ruff = 'ruff' }) do
  if vim.fn.executable(cmd) == 1 then
    vim.lsp.enable(name)
  else
    vim.schedule(function() vim.notify('Missing LSP executable: ' .. cmd, vim.log.levels.WARN) end)
  end
end

vim.diagnostic.config({
  virtual_text = false,
  underline = true,
  signs = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = true },
})
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('MinimalLsp', { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client then
      client.server_capabilities.semanticTokensProvider = nil
    end
    local function map(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = ev.buf, desc = desc })
    end
    map('gd', vim.lsp.buf.definition, 'Go to definition')
    map('gr', vim.lsp.buf.references, 'References (quickfix)')
    map('gD', vim.lsp.buf.declaration, 'Go to declaration')
    map('gi', vim.lsp.buf.implementation, 'Go to implementation')
    map('K', vim.lsp.buf.hover, 'Hover')
    map('<leader>rn', vim.lsp.buf.rename, 'Rename')
    map('<leader>ca', vim.lsp.buf.code_action, 'Code action')
    map('<leader>ds', vim.lsp.buf.document_symbol, 'Document symbols')
  end,
})
