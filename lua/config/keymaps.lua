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
  vim.keymap.set("n", "q", ":bd!<cr>", { buffer = true,nowait=true })
end
local function dict_pronounce()
  vim.system { 'trans', '-sp', '-b', vim.fn.expand '<cword>' }
end

map("n", "<cr>", enter, { nowait = true, expr = true })
map("n", "<bs>", "<c-6>", { desc="go swap file" })
map("i", "jk", "<esc>", {})
map("i", "kj", "<esc>", {})
map("n", "gss", dict_search, { desc = "sdcv dictionary search keyword" })
map("n", "gsS", dict_pronounce, { desc = "Pronounce the word under cursor" })

-- Move Lines
map("n", "<c-s-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
map("n", "<c-s-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
map("i", "<c-s-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<c-s-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<c-s-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
map("v", "<c-s-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })
map("n", "<leader>qq", "<cmd>q!<cr>", { desc = "Quick Quit" })

map("n", "<c-.>",
  function()
    require("lazyvim.util").terminal("/bin/zsh", { cwd="/home/siuoly/myLib" } )
  end, { desc="Ranger terminal"}
)
map("t", "<c-.>", "<Cmd>close<cr>",{desc="disable terminal"})
