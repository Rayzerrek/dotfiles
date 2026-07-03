-- Neovim 0.12+ Native LSP Configuration
-- Uses vim.lsp.config and vim.lsp.enable (introduced in 0.12)

-- Ustawienie spacji jako klawisza Leader
vim.g.mapleader = " "

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

-- Domyślnie wcięcia na 2 spacje (dla JS, TS i pozostałych języków)
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Używaj systemowego schowka (yank/paste współpracuje z systemem)
vim.opt.clipboard = "unnamedplus"

-- Ukryj natywny wskaźnik trybu (-- INSERT --), ponieważ lualine go dubluje
vim.opt.showmode = false

-- Ustawienie PowerShell (pwsh) jako domyślnej powłoki (shell) na Windowsie
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

-- Wcięcie na 4 spacje dedykowane dla Pythona
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

-- TypeScript Tools (highly optimized alternative to vtsls)
-- Uses pmizio/typescript-tools.nvim under the hood
require("plugins.typescript_tools").config()

-- Alternative: typescript-language-server (if vtsls is not available)
-- Uncomment this and comment out vtsls above if you prefer tsserver
-- vim.lsp.config["typescript-language-server"] = {
-- 	cmd = { "typescript-language-server", "--stdio" },
-- 	filetypes = {
-- 		"javascript",
-- 		"javascriptreact",
-- 		"javascript.jsx",
-- 		"typescript",
-- 		"typescriptreact",
-- 		"typescript.tsx",
-- 	},
-- 	root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
-- }

-- Ty Language Server for Python (Astral Type Checker)
-- Requires: ty installed: uv tool install ty
vim.lsp.config["ty"] = {
	cmd = { "ty", "server" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git", "uv.lock" },
	settings = {},
}

-- Ruff Language Server for Python (Astral Formatter/Linter)
-- Requires: ruff installed globally or via pip: pip install ruff
vim.lsp.config["ruff"] = {
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git", "uv.lock" },
	settings = {},
}

-- oxlint for TypeScript / JavaScript (fast linting)
-- Requires: oxlint installed globally or via npm: npm install -g oxlint
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

-- oxfmt for TypeScript / JavaScript (fast formatting)
-- Requires: oxfmt installed globally or via npm: npm install -g oxfmt
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

-- Global capabilities for nvim-cmp integration
vim.lsp.config("*", {
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

vim.lsp.enable({
	-- "vtsls", -- Disabled in favor of typescript-tools
	"ty",
	"ruff",
	"oxlint",
	"oxfmt",
	-- "typescript-language-server", -- Uncomment if using tsserver instead of vtsls
})

-- ============================================================================
-- Autocompletion (nvim-cmp)
-- ============================================================================

require("plugins.cmp").config()

-- ============================================================================
-- Keymaps
-- ============================================================================

-- Buffer-local keymaps applied when an LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local opts = { buffer = ev.buf, silent = true }
		local map = vim.keymap.set

		-- Inlay hints są domyślnie wyłączone; <leader>th przełącza je per bufor.
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client:supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(false, { bufnr = ev.buf })
			-- Skrót <leader>th do przełączania widoczności podpowiedzi w locie
			map("n", "<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
			end, { buffer = ev.buf, silent = true, desc = "Toggle Inlay Hints" })
		end

		-- Navigation
		map("n", "gd", vim.lsp.buf.definition, opts)
		map("n", "gD", vim.lsp.buf.declaration, opts)
		map("n", "gr", vim.lsp.buf.references, opts)
		map("n", "gi", vim.lsp.buf.implementation, opts)
		map("n", "gy", vim.lsp.buf.type_definition, opts)

		-- Information
		map("n", "K", vim.lsp.buf.hover, opts)
		map("n", "<C-k>", vim.lsp.buf.signature_help, opts)

		-- Actions
		map("n", "<leader>rn", vim.lsp.buf.rename, opts)
		map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

		-- Diagnostics
		map("n", "[d", vim.diagnostic.goto_prev, opts)
		map("n", "]d", vim.diagnostic.goto_next, opts)
		map("n", "<leader>e", vim.diagnostic.open_float, opts)
		map("n", "<leader>q", vim.diagnostic.setloclist, opts)

		-- Format
		map("n", "<leader>f", function()
			vim.lsp.buf.format({ async = true })
		end, opts)
	end,
})

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
		-- Otwórz poziomy podział (split) na dole o wysokości 15 linii
		vim.cmd("botright 15split")
		term_win = vim.api.nvim_get_current_win()
		
		if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
			-- Przywróć istniejący bufor terminala
			vim.api.nvim_win_set_buf(term_win, term_buf)
		else
			-- Utwórz nowy terminal
			vim.cmd("terminal")
			term_buf = vim.api.nvim_get_current_buf()
			
			-- Ukryj numery linii i kolumnę znaków w terminalu
			vim.opt_local.number = false
			vim.opt_local.relativenumber = false
			vim.opt_local.signcolumn = "no"
		end
		
		-- Automatycznie wejdź w tryb insert w terminalu
		vim.cmd("startinsert")
	end
end

-- Skrót Ctrl + ` (backtick) do otwierania/zamykania terminala (w trybie Normal i Terminal)
vim.keymap.set({ "n", "t" }, "<C-`>", toggle_terminal, { silent = true, desc = "Toggle Terminal" })

-- Skróty Ctrl + Strzałka w Górę / w Dół do płynnej regulacji wysokości okna
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { silent = true, desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { silent = true, desc = "Decrease window height" })
vim.keymap.set("t", "<C-Up>", "<C-\\><C-n>:resize +2<CR>i", { silent = true, desc = "Increase window height" })
vim.keymap.set("t", "<C-Down>", "<C-\\><C-n>:resize -2<CR>i", { silent = true, desc = "Decrease window height" })

-- ============================================================================
-- Statusline (lualine.nvim)
-- ============================================================================

require("plugins.lualine").config()
