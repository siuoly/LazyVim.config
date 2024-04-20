local keymap = vim.keymap.set
local opts = { silent = true ,buffer=true}
keymap("n", "<f5>" , [[<Cmd>exe  v:count1 . "TermExec cmd='lua %:p'"<cr>]], opts)
-- run script
keymap("n", "<f5>" , [[:!cmd.exe /c % &<cr>]],opts)
-- close all script : cmd.exe /c taskkill /im "autohotkey.exe"
keymap("n", "<f6>" , [[:!cmd.exe /c taskkill /im "autohotkey.exe"<cr>]],opts)

-- nnoremap <buffer> <f5> :!cmd.exe /c % &<cr>

