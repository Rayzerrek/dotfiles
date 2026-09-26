return {
  -- Commenting (Mitchell's setup: require('Comment').setup())
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
    },
  },

  -- GitHub Copilot (from Mitchell's home-manager.nix)
  {
    "github/copilot.vim",
    event = "InsertEnter",
    init = function()
      vim.g.copilot_no_tab_map = false
    end,
  },
}