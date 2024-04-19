-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local function enter()
  if vim.o.buftype == "nofile" or vim.o.ft == "qf" then
    return "<cr>"
  else
    return ":"
  end
end
local function dict_search()
  -- sdcv:dictionary command  grep:color output command
  vim.api.nvim_command([[terminal sdcv <cword>|grep --color=always -zP -e "-->.*\n"]])
  vim.cmd("tab split")
  vim.keymap.set("n", "q", ":bd!<cr>", { buffer = true })
end
local function dict_pronounce()
  local nvterm = require("nvterm.terminal")
  nvterm.send("trans -sp -b " .. vim.fn.expand("<cword>"), "float")
end

map("n", "<cr>", enter, { nowait = true, expr = true })
map("i", "jk", "<esc>", {})
map("i", "kj", "<esc>", {})
map("n", "gss", dict_search, { desc = "sdcv dictionary search keyword" })
map("n", "gsS", dict_pronounce, { desc = "Pronounce the word under cursor" })
