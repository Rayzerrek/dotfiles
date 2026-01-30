return {
  -- { "ellisonleao/gruvbox.nvim", priority = 1000 },
  -- { "joshdick/onedark.vim" },
  {
    "ThePrimeagen/harpoon",
    lazy = true,
  },
  {
    "sourcegraph/amp.nvim",
    branch = "main",
    lazy = false,
    opts = { auto_start = true, log_level = "info" },
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp" },
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      require("typescript-tools").setup({
        handlers = {
          ["textDocument/publishDiagnostics"] = function() end,
        },
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          local opts = { buffer = bufnr, remap = false }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
          vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
        end,
        settings = {
          separate_diagnostic_server = true,
          publish_diagnostic_on = "insert_leave",
          jsx_close_tag = {
            enable = true,
            filetypes = { "typescriptreact", "javascriptreact" },
          },
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
  },
  {
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
        javascript = { "biome-check", "prettierd", stop_after_first = true },
        javascriptreact = { "biome-check", "prettierd", stop_after_first = true },
        typescript = { "biome-check", "prettierd", stop_after_first = true },
        typescriptreact = { "biome-check", "prettierd", stop_after_first = true },
        json = { "biome-check", "prettierd", stop_after_first = true },
        python = { "black" },
      },
      formatters = {
        ["biome-check"] = {
          command = "biome",
          args = { "check", "--write", "--unsafe", "--stdin-file-path", "$FILENAME" },
          stdin = true,
          condition = function(_, ctx)
            return vim.fs.find({ "biome.json", "biome.jsonc" }, { path = ctx.filename, upward = true })[1] ~= nil
          end,
        },
      },
    },
  },
  { "windwp/nvim-ts-autotag" },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
      require("tiny-inline-diagnostic").setup({
        preset = "powerline",
        options = {
          add_messages = {
            display_count = true,
            messages = true,
          },
          multilines = {
            always_show = true,
            enabled = true,
          },
        },
      })
    end,
  },
  {
    "catppuccin/nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        -- float = {
        -- 	-- transparent = true,
        -- 	-- solid = false,
        -- },
        integrations = {
          diffview = true,
          fidget = true,
          harpoon = true,
          mason = true,
          native_lsp = { enabled = true },
          noice = true,
          notify = true,
          symbols_outline = true,
          snacks = {
            enabled = true,
            indent_scope_color = "mauve",
          },
          render_markdown = true,
          telescope = true,
          treesitter = true,
          treesitter_context = true,
          ufo = true,
          which_key = true,
        },
      })
      local palette = require("catppuccin.palettes").get_palette("macchiato")
      vim.cmd.colorscheme("catppuccin-macchiato")

      -- Telescope highlights to match editor background
      vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = palette.base })
      vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = palette.blue, bg = palette.base })
      vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = palette.base })
      vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = palette.blue, bg = palette.base })
      vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = palette.base })
      vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = palette.blue, bg = palette.base })
      vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = palette.base })
      vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = palette.blue, bg = palette.base })
      vim.api.nvim_set_hl(0, "TelescopeTitle", { fg = palette.mauve, bg = palette.base })
      vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = palette.mauve, bg = palette.base })
      vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = palette.mauve, bg = palette.base })
      vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = palette.mauve, bg = palette.base })

      -- Hide all semantic highlights until upstream issues are resolved (https://github.com/catppuccin/nvim/issues/480)
      for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
        vim.api.nvim_set_hl(0, group, {})
      end
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      local harpoon = require("harpoon.mark")

      local function harpoon_component()
        local total_marks = harpoon.get_length()

        if total_marks == 0 then
          return ""
        end

        local current_mark = "—"

        local mark_idx = harpoon.get_current_index()
        if mark_idx ~= nil then
          current_mark = tostring(mark_idx)
        end

        return string.format("󱡅 %s/%d", current_mark, total_marks)
      end

      require("lualine").setup({
        options = {
          theme = "catppuccin",
          globalstatus = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "█", right = "█" },
        },
        sections = {
          lualine_b = {
            "branch",
            harpoon_component,
            {
              "diff",
              source = function()
                local bufnr = vim.api.nvim_get_current_buf()
                local summary = vim.b[bufnr].vcsigns_summary
                if summary then
                  return {
                    added = summary.added or 0,
                    modified = summary.modified or 0,
                    removed = summary.removed or 0,
                  }
                end
                return nil
              end,
            },
            "diagnostics",
          },
          lualine_c = {
            { "filename", path = 1 },
          },
          lualine_x = {
            "filetype",
          },
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "l3mon4d3/luasnip",
    },
    opts = {
      diagnostics = {
        virtual_text = false
      }
    },
    config = function()
      local util = require("lspconfig.util")

      local on_attach = function(client, bufnr)
        if client.name == "ts_ls" then
          client.server_capabilities.codeActionProvider = false
          local root_dir = client.config.root_dir
          local has_biome = root_dir
              and (util.path.exists(util.path.join(root_dir, "biome.json"))
                or util.path.exists(util.path.join(root_dir, "biome.jsonc")))

          if has_biome then
            client.server_capabilities.diagnosticProvider = error
          end
        end

        local opts = { buffer = bufnr, remap = false }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "k", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<c-h>", function() vim.lsp.buf.signature_help() end, opts)
      end

      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      require("mason").setup()
      require("mason-lspconfig").setup({

        ensure_installed = {
          "lua_ls", "pyright", "html", "cssls", "zls",
        },
      })

      -- 4. setup autouzupełniania (cmp)
      local cmp = require('cmp')
      local cmp_select = { behavior = cmp.SelectBehavior.Select }

      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<c-p>'] = cmp.mapping.select_prev_item(cmp_select),
          ['<c-n>'] = cmp.mapping.select_next_item(cmp_select),
          ['<c-y>'] = cmp.mapping.confirm({ select = true }),
          ['<c-space>'] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
        }, {
          { name = 'buffer' },
        })
      })
    end
  },
  { "pacha/vem-tabline" },
  { "junegunn/rainbow_parentheses.vim" },
  { "majutsushi/tagbar" },
  { "tpope/vim-fugitive" },
  { "tpope/vim-surround" },
  { "aluriak/nerdcommenter" },
  { "haya14busa/vim-easymotion" },
  {
    "stevearc/oil.nvim",
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        -- use_default_keymaps = false,
        confirmation = {
          border = "rounded",
        },
        float = {
          border = "rounded",
        },
        keymaps = {
          ["<C-l>"] = false,
          ["<C-r>"] = "actions.refresh",
        },
        view_options = {
          show_hidden = true,
        },
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = { "javascript", "typescript", "python", "html", "css", "zig" },
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
  { "mattn/emmet-vim" },
  -- telescope i zależności
  { "nvim-lua/plenary.nvim" },
  { "nvim-telescope/telescope.nvim" },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufRead",
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = " ", texthl = "gitsignsadd" },
          change       = { text = " ", texthl = "gitsignschange" },
          delete       = { text = " ", texthl = "gitsignsdelete" },
          topdelete    = { text = " ", texthl = "gitsignsdelete" },
          changedelete = { text = " ", texthl = "gitsignschange" },
        },
        signcolumn = true,
        numhl = true,
      })
    end
  },
}
