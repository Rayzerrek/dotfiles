return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "catppuccin/nvim" },
  config = function()
    local harpoon = require("harpoon.mark")

    local function harpoon_component()
      local total_marks = harpoon.get_length()
      if total_marks == 0 then return "" end

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
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "filetype" },
      },
    })
  end,
}
