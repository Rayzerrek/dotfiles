return {
	spec = {
		{ src = "https://github.com/nvim-lua/plenary.nvim" },
		{ src = "https://github.com/pmizio/typescript-tools.nvim" },
	},
	config = function()
		require("typescript-tools").setup({
			capabilities = require("cmp_nvim_lsp").default_capabilities(),
			settings = {
				expose_as_code_action = "all", -- Exposes commands like Organize Imports, Add Missing Imports, etc.
				tsserver_file_preferences = {
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
			},
		})
	end,
}
