-- Mitchell Hashimoto's signature key mappings

local map = vim.keymap.set

-- Fast escape from insert mode (Mitchell's iconic jj/jk sequence)
local escapes = { "jj", "jJ", "Jj", "JJ", "jk", "jK", "Jk", "JK" }
for _, seq in ipairs(escapes) do
  map("i", seq, "<Esc>", { noremap = true, silent = true, desc = "Exit insert mode" })
end

-- Visual line movement (smooth navigation with wrapped lines)
map("n", "j", "gj", { noremap = true, silent = true })
map("n", "k", "gk", { noremap = true, silent = true })

-- Directory navigation
map("n", "<leader>cd", ":cd %:h<CR>", { noremap = true, silent = true, desc = "cd to current file directory" })
map("n", "<leader>lcd", ":lcd %:h<CR>", { noremap = true, silent = true, desc = "lcd to current file directory" })

-- Window / Split navigation (<C-h>, <C-j>, <C-k>, <C-l>)
map("n", "<C-j>", "<C-w>j", { noremap = true, silent = true, desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { noremap = true, silent = true, desc = "Go to upper window" })
map("n", "<C-h>", "<C-w>h", { noremap = true, silent = true, desc = "Go to left window" })
map("n", "<C-l>", "<C-w>l", { noremap = true, silent = true, desc = "Go to right window" })

-- Native tab management
map("n", "<C-t>", ":tabnew<CR>", { noremap = true, silent = true, desc = "New tab" })
map("n", "<C-c>", ":tabclose<CR>", { noremap = true, silent = true, desc = "Close tab" })
map("n", "<C-[>", ":tabprevious<CR>", { noremap = true, silent = true, desc = "Previous tab" })
map("n", "<C-]>", ":tabnext<CR>", { noremap = true, silent = true, desc = "Next tab" })

-- Clipboard shortcuts
map({ "n", "v" }, "<leader>y", '"+y', { noremap = true, desc = "Yank to system clipboard" })
map({ "n", "v" }, "<leader>p", '"+p', { noremap = true, desc = "Paste from system clipboard" })

-- Clear search highlights
map("n", "<leader>/", ":nohlsearch<CR>", { noremap = true, silent = true, desc = "Clear search highlight" })

-- Buffer management
map("n", "<leader>d", ":bd<CR>", { noremap = true, silent = true, desc = "Delete buffer" })

-- Terminal mode mappings
map("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true, desc = "Exit terminal mode" })
for _, seq in ipairs(escapes) do
  map("t", seq, "<C-\\><C-n>", { noremap = true, silent = true, desc = "Exit terminal mode" })
end
map("n", "<Leader>c", ":terminal<CR>", { noremap = true, silent = true, desc = "Open terminal" })

-- Command line path expansion
map("c", "%%", "<C-R>=expand('%:h').'/'<CR>", { noremap = true })

-- Quick edit config
map("n", "<leader>vimrc", ":e <CR>", { noremap = true, silent = true, desc = "Edit init.lua" })