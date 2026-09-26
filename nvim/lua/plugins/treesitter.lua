return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
    },
    opts = {
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
    },
    config = function(_, opts)
      local ok, ts_configs = pcall(require, "nvim-treesitter.configs")
      if ok then
        ts_configs.setup(opts)
      end
      local ok_ctx, ctx = pcall(require, "treesitter-context")
      if ok_ctx then
        ctx.setup({
          enable = true,
          max_lines = 3,
          trim_scope = "outer",
        })
      end
    end,
  },
}