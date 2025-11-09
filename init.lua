-- ========================
-- init.lua (converted from init.vim)
-- ========================

-- Map leader to space
vim.g.mapleader = " "

-- === Bootstrap lazy.nvim ===
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- === Plugins ===
require("lazy").setup({
  {

  { "dense-analysis/ale" , lazy = false},
    "vague-theme/vague.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000,
    config = function()
      require("vague").setup({
          transparent = false, -- don't set background
          -- disable bold/italic globally in `style`
          bold = true,
          italic = true,
          style = {
            -- "none" is the same thing as default. But "italic" and "bold" are also valid options
            boolean = "bold",
            number = "none",
            float = "none",
            error = "bold",
            comments = "italic",
            conditionals = "none",
            functions = "none",
            headings = "bold",
            operators = "none",
            strings = "italic",
            variables = "none",

            -- keywords
            keywords = "none",
            keyword_return = "italic",
            keywords_loop = "none",
            keywords_label = "none",
            keywords_exception = "none",

            -- builtin
            builtin_constants = "bold",
            builtin_functions = "none",
            builtin_types = "bold",
            builtin_variables = "none",
          },
          -- plugin styles where applicable
          -- make an issue/pr if you'd like to see more styling options!
            plugins = {
              cmp = {
                match = "bold",
                match_fuzzy = "bold",
              },
              dashboard = {
                footer = "italic",
              },
              lsp = {
                diagnostic_error = "bold",
                diagnostic_hint = "none",
                diagnostic_info = "italic",
                diagnostic_ok = "none",
                diagnostic_warn = "bold",
              },
              neotest = {
                focused = "bold",
                adapter_name = "bold",
              },
              telescope = {
                match = "bold",
              },
            },

            -- Override highlights or add new highlights
            on_highlights = function(highlights, colors) end,

            -- Override colors
            colors = {
              bg = "#141415",
              inactiveBg = "#1c1c24",
              fg = "#cdcdcd",
              floatBorder = "#878787",
              line = "#252530",
              comment = "#606079",
              builtin = "#b4d4cf",
              func = "#c48282",
              string = "#e8b589",
              number = "#e0a363",
              property = "#c3c3d5",
              constant = "#aeaed1",
              parameter = "#bb9dbd",
              visual = "#333738",
              error = "#d8647e",
              warning = "#f3be7c",
              hint = "#7e98e8",
              operator = "#90a0b5",
              keyword = "#6e94b2",
              type = "#9bb4bc",
              search = "#405065",
              plus = "#7fa563",
              delta = "#f3be7c",
            },
          })
        vim.cmd("colorscheme vague")
      end-- make sure to load this before all the other plugins
    },
  { "joshdick/onedark.vim" },
  { "tomasiser/vim-code-dark" },
  { "vim-airline/vim-airline" },
  { "vim-airline/vim-airline-themes" },
  { "pacha/vem-tabline" },
  { "yggdroot/indentline" },
  { "junegunn/rainbow_parentheses.vim" },
  { "folke/tokyonight.nvim" },
  { "airblade/vim-gitgutter" },
  { "preservim/nerdtree" },
  { "majutsushi/tagbar" },
  { "tpope/vim-fugitive" },
  { "tpope/vim-surround" },
  { "aluriak/nerdcommenter" },
  { "tomtom/tcomment_vim" },
  { "haya14busa/vim-easymotion" },
  { "wincent/terminus" },
  { "cespare/vim-toml" },
  { "sheerun/vim-polyglot" },

  -- Telescope i zależności
  { "nvim-lua/plenary.nvim" },
  { "nvim-telescope/telescope.nvim" },
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    config = function()
      require("gitsigns").setup({
          signs = {
            add          = { text = " ", texthl = "GitSignsAdd" },
            change       = { text = " ", texthl = "GitSignsChange" },
            delete       = { text = " ", texthl = "GitSignsDelete" },
            topdelete    = { text = " ", texthl = "GitSignsDelete" },
            changedelete = { text = " ", texthl = "GitSignsChange" },
          },
          signcolumn = true,  -- kolumna numerów linii
          numhl = true,       -- podświetlenie numerów linii zamiast znaków
          linehl = false,
          word_diff = false,
          current_line_blame = false,
        })
    end
  },

})




vim.g.ale_echo_msg_format = 0
vim.g.ale_lint_on_text_changed = 'never'
vim.g.ale_lint_on_insert_leave = 0
vim.g.ale_javascript_tsserver_use_local = 1
vim.g.ale_javascript_tsserver_use_global = 0
vim.g.ale_javascript_tsserver_executable = "node_modules/.bin/tsserver.cmd"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.shortmess:append("I")
vim.opt.laststatus = 2
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.hidden = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.errorbells = true
vim.opt.visualbell = true
vim.opt.showmatch = false
vim.opt.mouse:append("a")
vim.opt.listchars = { tab = "› ", eol = "¬", trail = "⋅" }
vim.opt.langmenu = "en"
vim.env.LANG = "en"
vim.opt.shell = "pwsh"
vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
vim.opt.shellquote = "\""
vim.opt.shellxquote = ""
vim.opt.clipboard = "unnamedplus"

vim.g.NERDTreeShowHidden = 1
vim.cmd("colorscheme vague")

vim.g['airline_section_a'] = ''

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<Leader><Tab>", ":bnext<CR>", opts)
map("n", "<Leader><S-Tab>", ":bprev<CR>", opts)

map("n", "<Leader>y", '"+y', opts)
map("n", "<Leader>p", '"+p', opts)

map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)
map("n", "<C-h>", "<C-w>h", opts)

map("n", "S", ":%s//g<Left><Left>", { noremap = true })
map("n", "Q", "<Nop>", { noremap = true }) -- wyłącz Ex mode

map("n", "<C-n>", ":NERDTreeToggle<CR>", opts)
map("n", "<C-f>", ":NERDTreeFind<CR>", opts)

-- Telescope
local telescope = require("telescope")
telescope.setup({
  defaults = {
    layout_config = { prompt_position = "top" },
    sorting_strategy = "ascending",
    file_ignore_patterns = { "node_modules", "%.git", "target" },
  },
})
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)
map("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", opts)
map("n", "<leader>fc", "<cmd>Telescope commands<cr>", opts)
map("n", "<leader>fr", "<cmd>Telescope registers<cr>", opts)

-- CtrlP
vim.g.ctrlp_map = "<c-p>"
vim.g.ctrlp_cmd = "CtrlP"

vim.g.vim_markdown_conceal = 0
vim.g.vim_markdown_conceal_code_blocks = 0
vim.g.vim_json_conceal = 0
vim.g.indentLine_fileTypeExclude = { "markdown", "md" }
vim.g.markdown_fenced_languages = { "python", "js=javascript", "ruby", "ts=typescript" }

-- IndentLine
vim.g.indentLine_leadingSpaceChar = "·"
vim.g.indentLine_leadingSpaceEnabled = 1

-- Rainbow parentheses
vim.g["rainbow#pairs"] = { { "(", ")" }, { "[", "]" }, { "{", "}" } }

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.exists(":NoMatchParen") == 2 then
      vim.cmd("NoMatchParen")
    end
  end,
})


