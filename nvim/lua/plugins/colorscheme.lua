return {
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    config = function()
      require("onedark").setup({
        style = "dark", -- OneHalfDark style
        transparent = false,
        term_colors = true,
        ending_tildes = false,
        cmp_itemkind_reverse = false,
        toggle_style_key = nil,
        code_style = {
          comments = "italic",
          keywords = "none",
          functions = "none",
          strings = "none",
          variables = "none",
        },
        colors = {
          bg = "#282c34",
          fg = "#dcdfe4",
          red = "#e06c75",
          green = "#98c379",
          yellow = "#e5c07b",
          blue = "#61afef",
          purple = "#c678dd",
          cyan = "#56b6c2",
          gray = "#5d677a",
          dark_gray = "#313640",
          highlight = "#3e4452",
        },
        highlights = {
          WinSeparator = { fg = "#3e4452", bg = "NONE" },
          VertSplit = { fg = "#3e4452", bg = "NONE" },
          CursorLine = { bg = "#2c313a" },
          ColorColumn = { bg = "#2c313a" },
        },
      })
      require("onedark").load()
    end,
  },
}