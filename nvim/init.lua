-- Neovim 0.12+ Native LSP Configuration
-- Uses vim.lsp.config and vim.lsp.enable (introduced in 0.12)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================================================
-- Native Plugin Manager (vim.pack) -- Neovim 0.12+
-- ============================================================================

local plugins = {
	"plugins.vesper",
	"plugins.cmp",
	"plugins.typescript_tools",
	"plugins.oil",
	"plugins.lualine",
}

local specs = {}
for _, plugin in ipairs(plugins) do
	local p = require(plugin)
	if p.spec then
		if p.spec.src then
			table.insert(specs, p.spec)
		else
			for _, sub_spec in ipairs(p.spec) do
				table.insert(specs, sub_spec)
			end
		end
	end
end

vim.pack.add(specs)

-- ============================================================================
-- Colorscheme
-- ============================================================================

require("plugins.vesper").config()

-- ============================================================================
-- Options & Indentation (Neovim Native Options)
-- ============================================================================

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.clipboard = "unnamedplus"
vim.opt.showmode = false

local powershell_options = {
	shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell",
	shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy Bypass -Command [Console]::InputEncoding=[System.Text.Encoding]::UTF8;[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;$Input|Out-String|Invoke-Expression",
	shellredir = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
	shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
	shellquote = "",
	shellxquote = "",
}

for option, value in pairs(powershell_options) do
	vim.opt[option] = value
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.expandtab = true
	end,
})

-- ============================================================================
-- Global LSP Settings
-- ============================================================================

vim.diagnostic.config({
	virtual_text = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
		},
	},
})

-- ============================================================================
-- Native LSP Server Configurations (vim.lsp.config)
-- ============================================================================

require("plugins.typescript_tools").config()

vim.lsp.config["ty"] = {
	cmd = { "ty", "server" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git", "uv.lock" },
	settings = {},
}

vim.lsp.config["ruff"] = {
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git", "uv.lock" },
	settings = {},
}

vim.lsp.config["oxlint"] = {
	cmd = { "oxlint", "--lsp" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
	root_markers = { "package.json", "tsconfig.json", ".git", ".oxlintrc.json" },
	settings = {
		run = "onSave",
	},
}

vim.lsp.config["oxfmt"] = {
	cmd = { "oxfmt", "--lsp" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
	root_markers = { "package.json", "tsconfig.json", ".git" },
}

-- ============================================================================
-- Enable LSP Servers (vim.lsp.enable)
-- ============================================================================

vim.lsp.config("*", {
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

vim.lsp.enable({
	"ty",
	"ruff",
	"oxlint",
	"oxfmt",
})

-- ============================================================================
-- Autocompletion (nvim-cmp)
-- ============================================================================

require("plugins.cmp").config()

-- ============================================================================
-- Keymaps
-- ============================================================================

local format_on_save_enabled = true

-- Buffer-local keymaps applied when an LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local function map(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
		end

		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client:supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(false, { bufnr = ev.buf })
			vim.keymap.set("n", "<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
			end, { buffer = ev.buf, silent = true, desc = "Toggle Inlay Hints" })
		end

		map("<C-]>", vim.lsp.buf.definition, "Go to definition")
		map("K", vim.lsp.buf.hover, "Hover")
		map("gD", vim.lsp.buf.implementation, "Go to implementation")
		map("1gD", vim.lsp.buf.type_definition, "Go to type definition")
		map("gR", vim.lsp.buf.references, "References")
		map("g0", vim.lsp.buf.document_symbol, "Document symbols")
		map("gW", vim.lsp.buf.workspace_symbol, "Workspace symbols")
		map("gd", vim.lsp.buf.declaration, "Go to declaration")
		map("ga", vim.lsp.buf.code_action, "Code action")
		map("gr", vim.lsp.buf.rename, "Rename")
		map("g[", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end, "Previous diagnostic")
		map("g]", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, "Next diagnostic")
		map("<leader>ft", function()
			format_on_save_enabled = not format_on_save_enabled
			print(string.format("format on save: %s", format_on_save_enabled))
		end, "Toggle format on save")
		map("<C-k>", vim.lsp.buf.signature_help, "Signature help")
		map("<leader>e", vim.diagnostic.open_float, "Open diagnostic float")
		map("<leader>q", vim.diagnostic.setloclist, "Set loclist")
		map("<leader>f", function()
			vim.lsp.buf.format({ async = true })
		end, "Format buffer")
	end,
})

vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result centered" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

vim.keymap.set("n", "<leader>h", function()
	vim.o.hlsearch = not vim.o.hlsearch
end, { desc = "Toggle search highlight" })

vim.keymap.set("n", "<leader>co", vim.cmd.copen, { desc = "Open quickfix" })
vim.keymap.set("n", "<leader>cl", vim.cmd.cclose, { desc = "Close quickfix" })

vim.keymap.set("n", "<leader>tw", function()
	local view = vim.fn.winsaveview()
	vim.cmd([[keeppatterns %s/\s\+$//e]])
	vim.fn.winrestview(view)
end, { desc = "Delete trailing whitespace" })

-- ============================================================================
-- Auto-format on save (Neovim Native LSP)
-- ============================================================================

local function oxlint_fix_all(bufnr)
	local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "oxlint" })
	for _, client in ipairs(clients) do
		client:request_sync("workspace/executeCommand", {
			command = "oxc.fixAll",
			arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
		}, 1000, bufnr)
	end
end

vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("LspFormatOnSave", {}),
	pattern = { "*.py", "*.js", "*.ts", "*.jsx", "*.tsx" },
	callback = function(ev)
		if not format_on_save_enabled then
			return
		end

		local ft = vim.bo[ev.buf].filetype
		local is_javascript = ft == "javascript" or ft == "typescript" or ft == "javascriptreact" or ft == "typescriptreact"
		local formatter = is_javascript and "oxfmt" or "ruff"

		if is_javascript then
			oxlint_fix_all(ev.buf)
		end

		vim.lsp.buf.format({
			async = false,
			filter = function(client)
				return client.name == formatter
			end,
		})
	end,
})

-- ============================================================================
-- File Explorer (oil.nvim)
-- ============================================================================

require("plugins.oil").config()

-- ============================================================================
-- Terminal Toggle & Resize (Ctrl + ` and Ctrl + Arrows)
-- ============================================================================

local term_buf = nil
local term_win = nil

local function toggle_terminal()
	if term_win and vim.api.nvim_win_is_valid(term_win) then
		vim.api.nvim_win_close(term_win, true)
		term_win = nil
	else
		vim.cmd("botright 15split")
		term_win = vim.api.nvim_get_current_win()

		if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
			vim.api.nvim_win_set_buf(term_win, term_buf)
		else
			vim.cmd("terminal")
			term_buf = vim.api.nvim_get_current_buf()
			vim.opt_local.number = false
			vim.opt_local.relativenumber = false
			vim.opt_local.signcolumn = "no"
		end

		vim.cmd("startinsert")
	end
end

vim.keymap.set({ "n", "t" }, "<C-`>", toggle_terminal, { silent = true, desc = "Toggle Terminal" })

vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { silent = true, desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { silent = true, desc = "Decrease window height" })
vim.keymap.set("t", "<C-Up>", "<C-\\><C-n>:resize +2<CR>i", { silent = true, desc = "Increase window height" })
vim.keymap.set("t", "<C-Down>", "<C-\\><C-n>:resize -2<CR>i", { silent = true, desc = "Decrease window height" })

-- ============================================================================
-- Statusline (lualine.nvim)
-- ============================================================================

require("plugins.lualine").config()
