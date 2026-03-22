return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        file_ignore_patterns = { "node_modules", "%.git", "target" },
      },
    })

    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }
    map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
    map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
    map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
    map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)
    map("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", opts)
    map("n", "<leader>fc", "<cmd>Telescope commands<cr>", opts)
    map("n", "<leader>fr", "<cmd>Telescope registers<cr>", opts)
  end,
}
