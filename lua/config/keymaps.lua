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


-------- tmux shift alt enable
-- 定义起始功能键和目标键的基础值
local function map_modifier_function_key(start_f_key,start_modifier_key)
-- 遍历设置键映射
  for i = 1, 12 do
    local from_key = "<f" .. (start_f_key + i - 1) .. ">"
    local to_key = start_modifier_key .. i .. ">"
    vim.keymap.set("n", from_key, to_key, {remap=true,silent=true})
  end
end
map_modifier_function_key(13, "<S-F")
map_modifier_function_key(25, "<C-F")
map_modifier_function_key(37, "<C-S-F")
map_modifier_function_key(49, "<M-F")

-- TODO: reddit post
-- 1. 標題： make modifier + function key (e.g. <c-f1>) usable on kitty terminal with tmux
-- 2. answer:
-- 3. general kitty ok, because tmux not support
-- 4. github link tutoirial:
--    infocmp, grep c-v control-f1  : grep here is corresond
-- 5. test
--  map <f13> <S-f1>
--  map <S-f1> :echo "shift+f1"<cr>
-- note: <c-s-f1> f3, f5 is use by kitty, so i cannot user it
-- 6. I like this setting with dap, f1~f13 is fuuly use by a lot of debug key!!!!!
-- is use by kitty f1,f2,f5,f6,f7,f8,f9,f10,f11
