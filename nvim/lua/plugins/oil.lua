return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup({
      confirmation = { border = "rounded" },
      float = { border = "rounded" },
      keymaps = {
        ["<C-l>"] = false,
        ["<C-r>"] = "actions.refresh",
      },
      view_options = { show_hidden = true },
    })

    vim.keymap.set("n", "<Leader>n", function()
      require("oil").toggle_float()
    end, { desc = "Toggle oil file explorer" })
  end,
}
