return {
	spec = {
		{ src = "https://github.com/hrsh7th/nvim-cmp" },
		{ src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
		{ src = "https://github.com/hrsh7th/cmp-buffer" },
		{ src = "https://github.com/hrsh7th/cmp-path" },
	},
	config = function()
		local cmp = require("cmp")
		cmp.setup({
			sources = {
				{ name = "nvim_lsp" },
				{ name = "buffer" },
				{ name = "path" },
			},
			mapping = cmp.mapping.preset.insert({
				["<C-Space>"] = cmp.mapping.complete(),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<Tab>"] = cmp.mapping.select_next_item(),
				["<S-Tab>"] = cmp.mapping.select_prev_item(),
				["<C-e>"] = cmp.mapping.abort(),
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
			}),
		})
	end,
}
