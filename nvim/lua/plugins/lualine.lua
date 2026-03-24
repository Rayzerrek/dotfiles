return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  config = function()
    require("lualine").setup({
      options = {
        theme = "auto",
        globalstatus = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "█", right = "█" },
      },
      sections = {
        lualine_b = {
          "branch",
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
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "filetype" },
      },
    })
  end,
}
