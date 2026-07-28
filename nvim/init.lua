vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.cmd.syntax('enable')
vim.cmd('filetype plugin indent on')

vim.filetype.add({
  extension = {
    svx = 'markdown',
  },
  pattern = {
    ['.*%.md%.njk'] = 'markdown',
  },
})

local state_dir = vim.fn.stdpath('state')
local backup_dir = state_dir .. '/backup'
local undo_dir = state_dir .. '/undo'

vim.fn.mkdir(backup_dir, 'p')
vim.fn.mkdir(undo_dir, 'p')

vim.opt.clipboard:append('unnamedplus')
vim.o.showmode = true
vim.o.showcmd = true
vim.o.history = 500
vim.o.wildmenu = true
vim.o.scrolloff = 3
vim.o.number = true
vim.o.colorcolumn = '80'
vim.o.wrap = false
vim.o.showmatch = true
vim.o.backspace = 'indent,eol,start'
vim.o.joinspaces = false
vim.o.timeout = false
vim.o.ttimeout = true
vim.o.ttimeoutlen = 10
vim.o.termguicolors = true
vim.o.inccommand = 'nosplit'
vim.o.signcolumn = 'yes'

vim.o.undofile = true
vim.o.undodir = undo_dir .. '//'
vim.o.backup = true
vim.o.backupdir = backup_dir .. '//'
vim.o.swapfile = false

vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.shiftround = true
vim.o.expandtab = true

vim.o.list = true
vim.o.listchars = 'tab:▸ ,eol:¬,extends:❯,precedes:❮'
vim.o.ruler = true
vim.o.laststatus = 2
vim.o.tags = './tags;'
vim.opt.wildignore:append({ '*/.git/*', '*/.hg/*', '*/.svn/*', '*/vendor/bundle/*', '*/node_modules/*' })

if vim.fn.executable('rg') == 1 then
  vim.o.grepprg = 'rg --vimgrep'
end

vim.api.nvim_create_autocmd('VimResized', {
  command = 'wincmd =',
})

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind

    if name == 'fff.nvim' and (kind == 'install' or kind == 'update') then
      if not ev.data.active then
        vim.cmd.packadd('fff.nvim')
      end

      require('fff.download').download_or_build_binary()
    elseif name == 'nvim-treesitter' and (kind == 'install' or kind == 'update') then
      if not ev.data.active then
        vim.cmd.packadd('nvim-treesitter')
      end

      vim.cmd.TSUpdate()
    end
  end,
})

vim.pack.add({
  'https://github.com/nexxeln/vesper.nvim',
  { src = 'https://github.com/dmtrKovalenko/fff.nvim', name = 'fff.nvim' },
  'https://github.com/tpope/vim-surround',
  'https://github.com/bronson/vim-visual-star-search',
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/Wansmer/treesj',
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/stevearc/conform.nvim',
}, { confirm = false })

require('vesper').setup({
  transparent = false,
})

vim.cmd.colorscheme('vesper')

local function set_fff_highlights()
  vim.api.nvim_set_hl(0, 'FFFNormal', { fg = '#FFFFFF', bg = '#1A1A1A' })
  vim.api.nvim_set_hl(0, 'FFFBorder', { fg = '#282828', bg = '#1A1A1A' })
  vim.api.nvim_set_hl(0, 'FFFCursor', { bg = '#232323' })
end

set_fff_highlights()

vim.api.nvim_create_autocmd('ColorScheme', {
  callback = set_fff_highlights,
})

require('fff').setup({
  hl = {
    normal = 'FFFNormal',
    border = 'FFFBorder',
    cursor = 'FFFCursor',
    winhl = 'Normal:FFFNormal,FloatBorder:FFFBorder,FloatTitle:Title',
  },
})

require('oil').setup()

local treesitter_languages = {
  'bash',
  'c',
  'css',
  'go',
  'html',
  'javascript',
  'json',
  'lua',
  'markdown',
  'markdown_inline',
  'python',
  'query',
  'rust',
  'svelte',
  'toml',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'yaml',
}

require('nvim-treesitter.install').compilers = { 'zig' }
require('nvim-treesitter').setup()

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    local installed = {}
    for _, language in ipairs(require('nvim-treesitter').get_installed()) do
      installed[language] = true
    end

    local missing = {}
    for _, language in ipairs(treesitter_languages) do
      if not installed[language] then
        table.insert(missing, language)
      end
    end

    if #missing > 0 then
      require('nvim-treesitter').install(missing)
    end
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'c',
    'css',
    'go',
    'html',
    'javascript',
    'json',
    'jsonc',
    'lua',
    'markdown',
    'python',
    'rust',
    'sh',
    'svelte',
    'toml',
    'typescript',
    'typescriptreact',
    'vim',
    'vimdoc',
    'yaml',
  },
  callback = function()
    pcall(vim.treesitter.start)
    vim.bo.indentexpr = [[v:lua.require'nvim-treesitter'.indentexpr()]]
  end,
})

require('treesj').setup({
  use_default_keymaps = false,
})

vim.diagnostic.config({
  float = { source = 'always' },
  severity_sort = true,
})

vim.api.nvim_create_user_command("ConformDisable", function(args)
  if args.bang then
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable conform-autoformat-on-save",
  bang = true,
})

vim.api.nvim_create_user_command("ConformEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable conform-autoformat-on-save",
})

require('conform').setup({
  notify_on_error = false,
  default_format_opts = {
    async = true,
    timeout_ms = 500,
    lsp_format = "fallback",
  },
  format_after_save = function(buffer_number)
    if vim.g.disable_autoformat or vim.b[buffer_number].disable_autoformat then
      return
    end
    return {
      async = true,
      timeout_ms = 500,
      lsp_format = "fallback",
    }
  end,
  formatters_by_ft = {
    astro = { "oxfmt", "biome", "prettierd", stop_after_first = true },
    javascript = { "oxfmt", "biome", "prettierd", stop_after_first = true },
    typescript = { "oxfmt", "biome", "prettierd", stop_after_first = true },
    typescriptreact = { "oxfmt", "biome", "prettierd", stop_after_first = true },
    svelte = { "oxfmt", "prettierd", stop_after_first = true },
    lua = { "stylua" },
  },
  formatters = {
    oxfmt = {
      condition = function(_, ctx)
        return vim.fs.find({ ".oxfmtrc.json", ".oxfmtrc.jsonc" }, {
          path = ctx.filename,
          upward = true,
          stop = vim.uv.os_homedir(),
        })[1] ~= nil
      end,
    },
    biome = {
      condition = function(_, ctx)
        return vim.fs.find({ "biome.json", "biome.jsonc" }, {
          path = ctx.filename,
          upward = true,
          stop = vim.uv.os_homedir(),
        })[1] ~= nil
      end,
    },
    prettierd = {
      condition = function(_, ctx)
        return vim.fs.find({
          ".prettierrc",
          ".prettierrc.json",
          ".prettierrc.js",
          ".prettierrc.cjs",
          ".prettierrc.mjs",
          "prettier.config.js",
          "prettier.config.cjs",
          "prettier.config.mjs",
        }, {
          path = ctx.filename,
          upward = true,
          stop = vim.uv.os_homedir(),
        })[1] ~= nil
      end,
    },
  },
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local function map(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = ev.buf, desc = desc })
    end

    map('<C-]>', vim.lsp.buf.definition, 'Go to definition')
    map('K', vim.lsp.buf.hover, 'Hover')
    map('gD', vim.lsp.buf.implementation, 'Go to implementation')
    map('1gD', vim.lsp.buf.type_definition, 'Go to type definition')
    map('gR', vim.lsp.buf.references, 'References')
    map('g0', vim.lsp.buf.document_symbol, 'Document symbols')
    map('gW', vim.lsp.buf.workspace_symbol, 'Workspace symbols')
    map('gd', vim.lsp.buf.declaration, 'Go to declaration')
    map('ga', vim.lsp.buf.code_action, 'Code action')
    map('gr', vim.lsp.buf.rename, 'Rename')
    map('g[', function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, 'Previous diagnostic')
    map('g]', function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, 'Next diagnostic')
    map('<leader>ft', function()
      if vim.g.disable_autoformat or vim.b.disable_autoformat then
        vim.cmd.ConformEnable()
      else
        vim.cmd.ConformDisable()
      end
    end, 'Toggle format on save')
  end,
})

vim.lsp.config('biome', {
  cmd = { 'biome', 'lsp-proxy' },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'json', 'jsonc', 'css', 'svelte', 'astro', 'vue' },
  root_markers = { 'biome.json', 'biome.jsonc' },
})

vim.lsp.config('svelte', {
  cmd = { 'svelteserver', '--stdio' },
})

local lsp_executables = {
  biome = 'biome',
  svelte = 'svelteserver',
}

local function enable_lsp_if_executable(name)
  local config = vim.lsp.config[name]
  if not config or not config.cmd then
    return
  end

  local command = lsp_executables[name] or (type(config.cmd) == 'table' and config.cmd[1] or config.cmd)
  if type(command) ~= 'string' then
    return
  end

  if command and vim.fn.executable(command) == 1 then
    vim.lsp.enable(name)
  end
end

for _, server in ipairs({ 'biome', 'clangd', 'pyright', 'ruff', 'marksman', 'svelte', 'zls' }) do
  enable_lsp_if_executable(server)
end

vim.schedule(function()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].filetype ~= '' then
      vim.api.nvim_exec_autocmds('FileType', { buffer = bufnr, modeline = false })
    end
  end
end)

vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next search result centered' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous search result centered' })
vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Join lines and keep cursor position' })

vim.keymap.set('n', '<leader>h', function()
  vim.o.hlsearch = not vim.o.hlsearch
end, { desc = 'Toggle search highlight' })

vim.keymap.set('n', '<leader>co', vim.cmd.copen, { desc = 'Open quickfix' })
vim.keymap.set('n', '<leader>cl', vim.cmd.cclose, { desc = 'Close quickfix' })

vim.keymap.set('n', '<leader>tw', function()
  local view = vim.fn.winsaveview()
  vim.cmd([[keeppatterns %s/\s\+$//e]])
  vim.fn.winrestview(view)
end, { desc = 'Delete trailing whitespace' })

vim.keymap.set('n', '-', function()
  require('oil').open()
end, { desc = 'Open parent directory' })

vim.keymap.set('n', 'gS', function()
  require('treesj').split()
end, { desc = 'Split syntax node' })

vim.keymap.set('n', 'gJ', function()
  require('treesj').join()
end, { desc = 'Join syntax node' })

vim.keymap.set('n', '<leader><leader>', function()
  require('fff').find_files()
end, { desc = 'FFFind files' })

vim.keymap.set('n', '<leader>fg', function()
  require('fff').live_grep()
end, { desc = 'LiFFFe grep' })

vim.keymap.set('n', '<leader>fz', function()
  require('fff').live_grep({ grep = { modes = { 'fuzzy', 'plain' } } })
end, { desc = 'Live fffuzy grep' })

vim.keymap.set({ 'n', 'x' }, '<leader>fw', function()
  require('fff').live_grep_under_cursor()
end, { desc = 'Search current word / selection' })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.opt_local.textwidth = 80
    vim.opt_local.smartindent = true
    vim.opt_local.list = false
    vim.opt_local.formatoptions:remove('q')
    vim.opt_local.formatlistpat = [[^\s*\d\+\.\s\+\|^\s*[-*+]\s\+]]
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'python' },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  callback = function()
    vim.opt_local.formatoptions:append('roq')
    vim.opt_local.expandtab = false
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.list = false
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'rust', 'yaml' },
  callback = function()
    vim.opt_local.list = false
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'yaml',
  callback = function()
    vim.opt_local.number = true
    vim.opt_local.colorcolumn = '0'
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'sql',
  callback = function()
    vim.opt_local.commentstring = '-- %s'
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function()
    vim.opt_local.wrap = true
    vim.cmd(math.max(math.min(vim.fn.line('$'), 10), 3) .. 'wincmd _')
  end,
})

local function get_nushell_shell()
  local resolved = vim.fn.exepath("nu")
  if resolved ~= "" then
    return '"' .. resolved .. '"'
  end
  return "nu"
end

local nushell_options = {
  shell = get_nushell_shell(),
  shellcmdflag = "--login --stdin --no-newline -c",
  shelltemp = false,
  shellredir = "out+err> %s",
  shellpipe = "| complete | update stderr { ansi strip } | tee { get stderr | save --force --raw %s } | into record",
  shellquote = "",
  shellxquote = "",
}

for option, value in pairs(nushell_options) do
  vim.opt[option] = value
end

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
