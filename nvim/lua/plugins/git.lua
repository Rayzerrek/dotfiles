return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = vim.keymap.set
        local opts = { buffer = bufnr }

        map("n", "]c", function()
          if vim.wo.diff then return "]c" end
          vim.schedule(function() gs.next_hunk() end)
          return "<Ignore>"
        end, { expr = true, desc = "Next Git Hunk" })

        map("n", "[c", function()
          if vim.wo.diff then return "[c" end
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, { expr = true, desc = "Prev Git Hunk" })

        map("n", "<leader>hs", gs.stage_hunk, opts)
        map("n", "<leader>hr", gs.reset_hunk, opts)
        map("n", "<leader>hp", gs.preview_hunk, opts)
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, opts)
      end,
    },
  },
}