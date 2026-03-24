return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  config = function()
    -- Pobieramy ścieżkę do Masona, żeby znaleźć tsserver na Windowsie
    local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/"
    local tsserver_path = mason_bin .. "typescript-language-server.cmd"

    require("typescript-tools").setup({
      -- Wskazujemy ścieżkę do pliku wykonywalnego
      tsserver_path = tsserver_path,
      handlers = {
        ["textDocument/publishDiagnostics"] = function() end,
      },
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
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
