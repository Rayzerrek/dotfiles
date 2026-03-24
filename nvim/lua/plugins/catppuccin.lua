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
        mason = true,
        native_lsp = { enabled = true },
        noice = true,
        notify = true,
        symbols_outline = true,
        snacks = { enabled = true, indent_scope_color = "mauve" },
        render_markdown = true,
        treesitter = true,
        treesitter_context = true,
        ufo = true,
        which_key = true,
      },
    })
    local palette = require("catppuccin.palettes").get_palette("macchiato")
    vim.cmd.colorscheme("catppuccin-macchiato")

    local hl = vim.api.nvim_set_hl

    for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
      hl(0, group, {})
    end
  end,
}
