vim.cmd([[ 
let b:slime_bracketed_paste = 1 
let b:slime_cell_delimiter = "##%" 
]])
local keymap = vim.keymap.set
local opts = { silent = true, buffer = true, noremap = true }
-- vim-slime config -----
-- space-cr:region

keymap("n", "<space>r"      , [[<Cmd>SlimeSend0 expandcmd('\\%run %').. "\n"<cr>]], { desc="Slime run python file",silent = true, buffer = true })
keymap("n", "<space>w"      , [[<Cmd>SlimeSend0 expandcmd('<cword>').. "\n"<cr>]] , { desc="Slime run python cursor word",silent = true, buffer = true })
keymap("n", "<space>W"      , [[<Cmd>SlimeSend0 expandcmd('<cWORD>').. "\n"<cr>]] , { desc="Slime run python cursor WORD",silent = true, buffer = true })
keymap("n", "<space>n"      , [[<Cmd>SlimeSendCurrentLine<cr>]]                   , { desc="Slime run python current line",silent = true, buffer = true })
keymap("n", "<space><space>", [[<Plug>SlimeParagraphSend]]                        , { desc="Slime run python paragraph",silent = true, buffer = true })
keymap("x", "<space><space>", "<Plug>SlimeRegionSend"                             , { desc="Slime run python select region",noremap = true, buffer = true })
keymap("n", "<c-cr>"        , [[<Plug>SlimeSendCell]]                             , { desc="Slime run python notation region",remap = true, buffer = true })
-- keymap("n", "<space>c", ipython.run_class, {opts})
-- keymap("n", "<space>f", ipython.run_function, {opts})
------------ pdb -----------------------
local pdb = {}
pdb.file_point = function()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local file = vim.api.nvim_buf_get_name(0)
  return file .. ":" .. line
end

pdb.send = function(cmd)
  local command = "TermExec cmd=" .. '"' .. cmd .. '"'
  vim.api.nvim_command(command)
end

pdb.command = function(cmd)
  if cmd == "" then
    local file = vim.api.nvim_buf_get_name(0)
    local run = "python3 -m pdb " .. file
    local command = "TermExec cmd=" .. '"' .. run .. '"' .. " direction=vertical"
    vim.api.nvim_command(command)
  else
    pdb.send(cmd)
  end
end
-- ipython --pdb srcipy.py automaticall stop at error position
vim.api.nvim_create_user_command("Pdb", function(opt)
  pdb.command(opt.args)
end, { nargs = "?" })

pdb.n = function()
  pdb.send("n")
end
pdb.s = function()
  pdb.send("s")
end
pdb.c = function()
  pdb.send("c")
end
pdb.run = function()
  pdb.send("run")
end
pdb.unt = function()
  pdb.send("unt")
end
pdb.l = function()
  pdb.send("l .")
end
pdb.ll = function()
  pdb.send("ll")
end
pdb.u = function()
  pdb.send("u")
end
pdb.d = function()
  pdb.send("d")
end
pdb.b = function()
  pdb.send("b")
end
pdb.b_line = function()
  pdb.send("b " .. pdb.file_point())
end
pdb.c_line = function()
  pdb.send("c " .. pdb.file_point())
end
pdb.j = function()
  pdb.send("j")
end
pdb.j_line = function()
  pdb.send("j " .. vim.api.nvim_win_get_cursor(0)[1])
end
pdb.sticky = function()
  pdb.send("sticky")
end
pdb.exit = function()
  pdb.send("exit")
end
pdb.restart = function()
  pdb.send("exit")
end
pdb.word = function()
  pdb.send("<cword>")
end
pdb.WORD = function()
  pdb.send("<cWORD>")
end

keymap("n", "<a-b>", pdb.b_line, {})
keymap("n", "<a-u>", pdb.u, {})
keymap("n", "<a-i>", pdb.d, {})

keymap("n", "<a-h>", pdb.c_line, {})
keymap("n", "<a-j>", pdb.n, {})
keymap("n", "<a-k>", pdb.j_line, {})
keymap("n", "<a-n>", pdb.s, {})

keymap("n", "<a-l>", pdb.l, {})
keymap("n", "<a-;>", pdb.ll, {})
keymap("n", "<a-d>", pdb.exit, {})
keymap("n", "<a-s>", pdb.sticky, {})
keymap("n", "<a-r>", pdb.restart, {})
