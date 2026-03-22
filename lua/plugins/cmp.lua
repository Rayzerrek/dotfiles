return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "l3mon4d3/luasnip",
  },
  config = function()
    local cmp = require("cmp")
    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<c-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<c-n>"] = cmp.mapping.select_next_item(cmp_select),
        ["<c-y>"] = cmp.mapping.confirm({ select = true }),
        ["<c-space>"] = cmp.mapping.complete(),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
      }, {
        { name = "buffer" },
      })
    })
  end
}
