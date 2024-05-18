-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.o.rnu = false
vim.o.pumblend = 0 -- transparent, 0 is opaque
-- vim.o.winend = 30 -- transparent, 0 is opaque
vim.o.clipboard = "unnamedplus"
vim.api.nvim_set_hl(0,'@markup.italic.markdown_inline',{link="Italic"})
vim.g.markdown_folding=1
