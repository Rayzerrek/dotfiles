return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      return {
        options = {
          theme = "onedark",
          globalstatus = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = { statusline = { "dashboard", "lazy" } },
        },
        sections = {
          lualine_a = {
            {
              "mode",
              fmt = function(str)
                return str
              end,
            },
          },
          lualine_b = {
            { "branch", icon = "" },
            {
              "diff",
              symbols = { added = " ", modified = " ", removed = " " },
            },
          },
          lualine_c = {
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              symbols = { error = " ", warn = " ", info = " ", hint = " " },
            },
            {
              "filename",
              path = 1,
              symbols = { modified = " ●", readonly = " ", unnamed = "[No Name]" },
            },
          },
          lualine_x = {
            { "filetype", icon_only = false },
            { "encoding" },
            { "fileformat" },
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      }
    end,
  },
}