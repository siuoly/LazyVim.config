local keymap = vim.keymap.set
local opts = { silent = true, buffer = true }

local function map_exit(exit_key)
  keymap("n", exit_key, "<Cmd>bd<cr>", opts)
end
local function toggle_winsize()
  if vim.api.nvim_win_get_height(0) < 15 then
    print("maxize")
    vim.api.nvim_win_set_height(0, 100) -- maxize window
  else
    print("small")
    vim.api.nvim_win_set_height(0, 10) -- small window window
  end
end
local function run_python_file()
  vim.cmd([[w|new|res 10]])
  vim.cmd("terminal python3 #:p")
  map_exit("q")
  map_exit("<f5>")
  keymap("n", "<f6>", toggle_winsize, opts)
end
local function copy_breakpoint_fileline()
  local breakpoint = vim.fn.expand("%") .. ":" .. vim.fn.line(".")
  vim.fn.setreg("+", breakpoint)
end
keymap("n", "yb", copy_breakpoint_fileline, { buffer = true })
keymap("n", "<f5>", run_python_file, { buffer = true })
------------- Ipython Setting --------------------------------------------
local ipython = {}

ipython.run = function()
  vim.cmd([[ 
  call feedkeys("\<c-w>\<c-w>\<c-\>\<c-n>",'n')  
  call feedkeys("\"\"pi\<cr>",'n')
  call feedkeys("\<c-\>\<c-n>\<c-w>\<c-p>",'n')  
  ]])
  -- go to terminal window" paste register" , key enter go back"
end
ipython.copy_run = function(copy)
  vim.api.nvim_command("normal m'")
  vim.api.nvim_command("normal " .. copy)
  vim.api.nvim_command("normal `'")
  ipython.run()
end
ipython.send = function(cmd)
  local sendword = vim.fn.expandcmd(cmd)
  vim.fn.setreg("", sendword)
  ipython.run()
end
-- add newline for ipython block code new line
local reg_add_newline = function()
  vim.fn.setreg("", vim.fn.getreg("") .. "\n")
end
ipython.run_class = function()
  ipython.copy_run("yac")
end
ipython.run_function = function()
  ipython.copy_run("yaf")
end
ipython.run_block = function()
  ipython.copy_run("yip")
  reg_add_newline()
end
ipython.run_line = function()
  ipython.copy_run("yy")
end
ipython.run_select = function()
  ipython.copy_run("y")
  reg_add_newline()
end
ipython.run_file = function()
  ipython.send("\\%run %")
end
ipython.run_word = function()
  ipython.send("<cword>")
end
ipython.run_WORD = function()
  ipython.send("<cWORD>")
end
keymap("n", "<space>r", ipython.run_file, {})
keymap("n", "<space>c", ipython.run_class, {})
keymap("n", "<space>f", ipython.run_function, {})
keymap("n", "<space><space>", ipython.run_block, {})
keymap("x", "<space><space>", ipython.run_select, {})
keymap("n", "<space>q", ipython.run_line, {})
keymap("n", "<space>w", ipython.run_word, {})
keymap("n", "<space>W", ipython.run_WORD, {})

vim.api.nvim_create_user_command("Ipy", "TermExec cmd='ipython' direction=vertical", {})
ipython.clear = function()
  ipython.send("clear")
end
ipython.exit = function()
  ipython.send("exit")
end

------------- debugger setting -------------------------------------------
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
