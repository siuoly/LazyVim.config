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


map("n", "<C-Up>", "<cmd>resize +4<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -4<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -6<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +6<cr>", { desc = "Increase Window Width" })
map("n", "<cr>", enter, { nowait = true, expr = true })
map("n", "<bs>", "<c-6>", { desc="go swap file" })
map("i", "jk", "<esc>", {})
map("i", "kj", "<esc>", {})
-- Move Lines
map("n", "<c-s-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
map("n", "<c-s-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
map("i", "<c-s-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<c-s-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<c-s-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
map("v", "<c-s-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })
map("n", "<leader>qq", "<cmd>qa!<cr>", { desc = "Quick Quit" })

map("n", "<c-.>", function()
    require("lazyvim.util").terminal("/bin/zsh", { cwd="/home/siuoly/myLib" } )
  end, { desc="Ranger terminal"}
)
map("t", "<c-.>", "<Cmd>close<cr>",{desc="disable terminal"})


-------- tmux shift alt enable
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

-------- tmux select window keymap
for i = 1, 9 do
  map("n", "<leader>"..i, "<cmd>!tmux select-window -t "..i.."<cr>",{desc="tmux select window "..i})
end
