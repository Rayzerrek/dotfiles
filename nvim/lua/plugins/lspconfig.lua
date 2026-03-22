return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
  },
  opts = {
    diagnostics = {
      virtual_text = false
    }
  },
  config = function()
    -- W Neovim 0.11 zalecanym sposobem ustawiania mapowań jest autokomenda LspAttach
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, remap = false }
        local map = vim.keymap.set
        map("n", "gd", function() vim.lsp.buf.definition() end, opts)
        map("n", "k", function() vim.lsp.buf.hover() end, opts)
        map("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        map("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        map("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        map("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
        map("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
        map("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
        map("i", "<c-h>", function() vim.lsp.buf.signature_help() end, opts)
      end,
    })

    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "pyright", "html", "cssls"
      },
    })

    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    
    local servers = { "pyright", "html", "cssls" }
    
    for _, lsp in ipairs(servers) do
      -- Pobieramy domyślną konfigurację z nvim-lspconfig (bez używania starego API setup)
      pcall(require, "lspconfig.configs." .. lsp)
      
      -- Nadpisujemy capabilities w nowym API vim.lsp.config wprowadzonym w Nvim 0.11
      if vim.lsp.config and vim.lsp.config[lsp] then
        vim.lsp.config[lsp].capabilities = capabilities
        vim.lsp.enable(lsp)
      end
    end
  end
}
