return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  config = function()
    require("typescript-tools").setup({
      handlers = {
        ["textDocument/publishDiagnostics"] = function() end,
      },
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
      on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, remap = false }
        local map = vim.keymap.set
        map("n", "gd", vim.lsp.buf.definition, opts)
        map("n", "K", vim.lsp.buf.hover, opts)
        map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        map("n", "<leader>rn", vim.lsp.buf.rename, opts)
        map("n", "gr", vim.lsp.buf.references, opts)
        map("n", "[d", vim.diagnostic.goto_prev, opts)
        map("n", "]d", vim.diagnostic.goto_next, opts)
        map("i", "<C-h>", vim.lsp.buf.signature_help, opts)
      end,
      settings = {
        separate_diagnostic_server = true,
        publish_diagnostic_on = "insert_leave",
        jsx_close_tag = { enable = true, filetypes = { "typescriptreact", "javascriptreact" } },
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
        complete_function_calls = true,
        code_lens = "off",
        include_completions_with_insert_text = true,
      },
    })
  end,
}
