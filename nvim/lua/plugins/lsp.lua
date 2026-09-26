return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
        },
      })

      -- Keymaps matching Mitchell Hashimoto's exact LSP setup (from vim-misc.lua)
      local on_attach = function(client, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        local map = vim.keymap.set

        map("n", "gD", vim.lsp.buf.declaration, opts)
        map("n", "gd", vim.lsp.buf.definition, opts)
        map("n", "K", vim.lsp.buf.hover, opts)
        map("n", "gi", vim.lsp.buf.implementation, opts)
        map("n", "gs", vim.lsp.buf.signature_help, opts)
        map("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
        map("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
        map("n", "<space>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
        map("n", "<space>D", vim.lsp.buf.type_definition, opts)
        map("n", "<space>rn", vim.lsp.buf.rename, opts)
        map("n", "<space>ca", vim.lsp.buf.code_action, opts)
        map("n", "gr", vim.lsp.buf.references, opts)
        map("n", "<space>e", vim.diagnostic.open_float, opts)
        map("n", "[d", vim.diagnostic.goto_prev, opts)
        map("n", "]d", vim.diagnostic.goto_next, opts)
        map("n", "<space>q", vim.diagnostic.setloclist, opts)
        map("n", "<space>f", function() vim.lsp.buf.format({ async = true }) end, opts)

        -- Auto format on save for Go and Zig
        if client.name == "gopls" or client.name == "zls" then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ timeout_ms = 2000 })
            end,
          })
        end
      end

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local servers = {
        zls = {},
        gopls = {},
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = { checkThirdParty = false },
            },
          },
        },
        ts_ls = {},
        pyright = {},
        clangd = {},
      }

      require("mason-lspconfig").setup({
        ensure_installed = { "gopls", "zls", "lua_ls" },
        automatic_installation = true,
      })

      local lspconfig = require("lspconfig")
      for server, config in pairs(servers) do
        config.capabilities = capabilities
        config.on_attach = on_attach
        if lspconfig[server] then
          lspconfig[server].setup(config)
        end
      end
    end,
  },
}