-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here


-- Disable autoformat for lua files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "sh", "lua", "python" },
  callback = function()
    vim.b.autoformat = false
  end,
})
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "markdown" },
  command = "setlocal nospell",
})
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "vim" },
  command = "if &bt=='nofile' | map <buffer> q :q<cr>| end",
})
