return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    ensure_installed = { "javascript", "typescript", "python", "html", "css" },
    highlight = { enable = true },
    indent = { enable = true },
  },
}
