local keymap = vim.keymap.set
local opts = { silent = true ,buffer=true}

keymap("n", "<f3>" , [[<Cmd>w|so %<cr>]], {silent=false,buffer=true})
-- keymap("n", "<f6>" , [[<Cmd>w|exe  v:count1 . "TermExec cmd='lua %:p'"<cr>]], opts)
-- vim.keymap.set("n", "<f4>" , "yy:lua <c-r>\"<cr>",{buffer=true})
