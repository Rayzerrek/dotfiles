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
