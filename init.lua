
-- Map leader to space
vim.g.mapleader = " "

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

    { "ellisonleao/gruvbox.nvim", priority = 1000},
--    { "joshdick/onedark.vim" },
    {
      'nvim-lualine/lualine.nvim',
      config = function()
        require('lualine').setup({
            options = {
              theme = 'gruvbox_dark',
              icons_enabled = false,
            },
            sections = {
              lualine_a = {},
              lualine_b = {
                {'filetype', icon = false },
              },
              lualine_c = {
                {'filename', icon = false}
              },
              lualine_x = {'encoding'}, 
              lualine_y = {},
              lualine_z = {},

            },
            inactive_sections = {
              lualine_b = {
                {'filetype', icon = false}
              }
            }

          })
      end
    },
  {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
        },
        config = function()
            local on_attach = function(client, bufnr)
                local opts = { buffer = bufnr, remap = false }
                vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
                vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
                vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
                vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
                vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
                vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
                vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
                vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
                vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
            end

            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            require("mason").setup()
            
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls", "pyright", "ts_ls", "html", "cssls", 
                    "rust_analyzer", "gopls", "jdtls",
                },
                handlers = {
                    function(server_name)
                        require("lspconfig")[server_name].setup({
                            on_attach = on_attach,
                            capabilities = capabilities,
                        })
                    end,
                }
            })

            -- 4. Setup Autouzupełniania (CMP)
            local cmp = require('cmp')
            local cmp_select = { behavior = cmp.SelectBehavior.Select }

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                    ['<C-Space>'] = cmp.mapping.complete(),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                }, {
                    { name = 'buffer' },
                })
            })
        end
    }, 
    { "pacha/vem-tabline" },
    { "junegunn/rainbow_parentheses.vim" },
    { "preservim/nerdtree" },
    { "majutsushi/tagbar" },
    { "tpope/vim-fugitive" },
    { "tpope/vim-surround" },
    { "aluriak/nerdcommenter" },
    { "haya14busa/vim-easymotion" },
    { 'nvim-treesitter/nvim-treesitter', build= ":TSUpdate", lazy=false,
  config = function()
    require('nvim-treesitter.install').compilers = {"zig"}
    require('nvim-treesitter.configs').setup({
      ensure_installed = {"javascript", "typescript", "python", "html", "css", "rust", "go", "java"},
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
    },
    { "mattn/emmet-vim" },
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
            signcolumn = true,
            numhl = true,
            linehl = false,
            word_diff = false,
            current_line_blame = false,
          })
      end
    },

  })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "rust" },
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
})



vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.shortmess:append("I")
vim.opt.laststatus = 2
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
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
vim.o.background = "dark"
vim.g.user_emmet_leader_key = '<C-E>'
vim.g.user_emmet_expandabbr_key = '<C-E>,'
vim.g.user_emmet_mode = 'i'
vim.g.user_emmet_install_global = 1


vim.g.NERDTreeShowHidden = 1
vim.cmd("colorscheme gruvbox")


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
map("n", "Q", "<Nop>", { noremap = true })

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


vim.g.vim_markdown_conceal = 0
vim.g.vim_markdown_conceal_code_blocks = 0
vim.g.vim_json_conceal = 0
vim.g.indentLine_fileTypeExclude = { "markdown", "md" }
vim.g.markdown_fenced_languages = { "python", "js=javascript", "ruby", "ts=typescript" }

-- Rainbow parentheses
vim.g["rainbow#pairs"] = { { "(", ")" }, { "[", "]" }, { "{", "}" } }

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      if vim.fn.exists(":NoMatchParen") == 2 then
        vim.cmd("NoMatchParen")
      end
    end,
  })


