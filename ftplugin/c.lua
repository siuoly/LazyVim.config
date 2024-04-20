local keymap = vim.keymap.set
local opts = { silent = true ,buffer=true}
keymap("n", "<f5>" , [[<Cmd>w|exe  v:count1 . "TermExec cmd='gcc %:p && ./a.out'"<cr>]], opts)
keymap("n", ";;" , [[<Cmd>s/;$\|$/;<cr><Cmd>noh<cr>``]], opts)  -- append ";" at end of line, then move back to origin position
