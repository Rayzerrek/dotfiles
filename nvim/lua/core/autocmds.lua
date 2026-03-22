local autocmd = vim.api.nvim_create_autocmd

autocmd("FileType", {
  pattern = { "python", "rust", "go" },
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
})

autocmd("VimEnter", {
  callback = function()
    if vim.fn.exists(":NoMatchParen") == 2 then
      vim.cmd("NoMatchParen")
    end
  end,
})
