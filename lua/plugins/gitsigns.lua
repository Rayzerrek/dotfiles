return {
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
  end,
}
