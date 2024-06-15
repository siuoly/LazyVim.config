vim.opt_local.spell = false
vim.opt_local.number = false
local keymap = vim.keymap.set
local opts = { silent = true ,buffer=true}
-- keymap("n","gcc","I~<esc>A~<esc>",opts)
keymap("x","gc","gsa~",{silent=true,buffer=true,remap=true})

-- vim.keymap.set('n', 'K', function()
--   vim.cmd 'silent! ?^##\\+\\s.*$'
--   vim.cmd 'nohlsearch'
-- end, { desc = 'Go to previous markdown header',buffer=true })

-- vim.keymap.set('n', 'J', function()
--   vim.cmd 'silent! /^##\\+\\s.*$'
--   vim.cmd 'nohlsearch'
-- end, { desc = 'Go to next markdown header' ,buffer=true})

-- surround
vim.keymap.set("x", "<c-0>","gsa)",   {buffer = true,remap=true,desc="markdown bold"})
vim.keymap.set("x", "<c-b>","2gsa*",   {buffer = true,remap=true,desc="markdown bold"})
vim.keymap.set("x", "<c-i>","gsa*" ,   {buffer = true,remap=true,desc="markdown italic"})
vim.keymap.set("x", "<c-]>","gsa]" ,   {buffer = true,remap=true,desc="markdown bracket"})
vim.keymap.set("x", "<c-s>","gsa~" ,   {buffer = true,remap=true,desc="markdown striketrhough"})
vim.keymap.set("x", "<c-`>","gsa`" ,   {buffer = true,remap=true,desc="markdown backtick"})
vim.keymap.set("n", "<c-b>","2gsaiw*" ,{buffer = true,remap=true,desc="markdown bracket"})
vim.keymap.set("n", "<c-i>","gsaiw*" , {buffer = true,remap=true,desc="markdown bracket"})
vim.keymap.set("n", "<c-`>","gsaiw`" , {buffer = true,remap=true,desc="markdown bracket"})
vim.keymap.set("n", "<c-s>","gsaiw~" , {buffer = true,remap=true,desc="markdown bracket"})
