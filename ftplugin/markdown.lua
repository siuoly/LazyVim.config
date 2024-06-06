vim.opt_local.spell = false
vim.opt_local.number = false
local keymap = vim.keymap.set
local opts = { silent = true ,buffer=true}
-- keymap("n","gcc","I~<esc>A~<esc>",opts)
keymap("x","gc","gsa~",{silent=true,buffer=true,remap=true})

-- Search UP for a markdown header
-- Make sure to follow proper markdown convention, and you have a single H1
-- heading at the very top of the file
-- This will only search for H2 headings and above
vim.keymap.set('n', 'K', function()
  vim.cmd 'silent! ?^##\\+\\s.*$'
  vim.cmd 'nohlsearch'
end, { desc = 'Go to previous markdown header',buffer=true })

vim.keymap.set('n', 'J', function()
  vim.cmd 'silent! /^##\\+\\s.*$'
  -- Clear the search highlight
  vim.cmd 'nohlsearch'
end, { desc = 'Go to next markdown header' ,buffer=true})
-- vim.diagnostic.disable(0)

-- surround
vim.keymap.set("x", "<c-b>","2gsa*",{remap=true,desc="markdown bold"})
vim.keymap.set("x", "<c-i>","gsa*" ,{remap=true,desc="markdown italic"})
vim.keymap.set("x", "<c-[>","gsa]" ,{remap=true,desc="markdown bracket"})
vim.keymap.set("x", "<c-s>","gsa~" ,{remap=true,desc="markdown striketrhough"})
vim.keymap.set("x", "<c-`>","gsa`" ,{remap=true,desc="markdown backtick"})
vim.keymap.set("n", "<c-b>","2gsaiw*" ,{remap=true,desc="markdown bracket"})
vim.keymap.set("n", "<c-i>","gsaiw*" ,{remap=true,desc="markdown bracket"})
vim.keymap.set("n", "<c-`>","gsaiw`" ,{remap=true,desc="markdown bracket"})
vim.keymap.set("n", "<c-s>","gsaiw~" ,{remap=true,desc="markdown bracket"})
