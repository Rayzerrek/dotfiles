return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      integrations = {
        diffview = true,
        fidget = true,
        harpoon = true,
        mason = true,
        native_lsp = { enabled = true },
        noice = true,
        notify = true,
        symbols_outline = true,
        snacks = { enabled = true, indent_scope_color = "mauve" },
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

    local hl = vim.api.nvim_set_hl
    hl(0, "TelescopeNormal", { bg = palette.base })
    hl(0, "TelescopeBorder", { fg = palette.blue, bg = palette.base })
    hl(0, "TelescopePromptNormal", { bg = palette.base })
    hl(0, "TelescopePromptBorder", { fg = palette.blue, bg = palette.base })
    hl(0, "TelescopeResultsNormal", { bg = palette.base })
    hl(0, "TelescopeResultsBorder", { fg = palette.blue, bg = palette.base })
    hl(0, "TelescopePreviewNormal", { bg = palette.base })
    hl(0, "TelescopePreviewBorder", { fg = palette.blue, bg = palette.base })
    hl(0, "TelescopeTitle", { fg = palette.mauve, bg = palette.base })
    hl(0, "TelescopePromptTitle", { fg = palette.mauve, bg = palette.base })
    hl(0, "TelescopeResultsTitle", { fg = palette.mauve, bg = palette.base })
    hl(0, "TelescopePreviewTitle", { fg = palette.mauve, bg = palette.base })

    for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
      hl(0, group, {})
    end
  end,
}
