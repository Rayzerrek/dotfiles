return {
	spec = { src = "https://github.com/stevearc/oil.nvim" },
	config = function()
		require("oil").setup({
			default_file_explorer = true,
			view_options = {
				show_hidden = true,
			},
		})
		vim.keymap.set("n", "-", "<CMD>Oil<CR>", { silent = true, desc = "Open parent directory" })
	end,
}
