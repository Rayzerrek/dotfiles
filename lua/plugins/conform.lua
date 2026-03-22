return {
  "stevearc/conform.nvim",
  opts = {
    notify_on_error = true,
    default_format_opts = {
      timeout_ms = 3000,
      lsp_format = "fallback",
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_format = "fallback",
    },
    formatters_by_ft = {
      javascript = { "oxlint", stop_after_first = true },
      javascriptreact = { "oxlint", stop_after_first = true },
      typescript = { "oxlint", stop_after_first = true },
      typescriptreact = { "oxlint", stop_after_first = true },
      json = { "oxlint", stop_after_first = true },
      python = { "black" },
    },
    formatters = {
      oxlint = {
        command = "oxlint",
        args = { "--fix", "$FILENAME" },
        stdin = false,
      },
    },
  },
}
