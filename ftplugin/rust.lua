
local keymap = vim.keymap.set
local opts = { silent = true ,buffer=true}
-- keymap("n", "<f5>" , [[<Cmd>w|!rustc %:p -o %:p:r && %:p:r<cr>]], {buffer=true})

local function map_exit(exit_key) keymap("n",exit_key,"<Cmd>bd<cr>",opts) end
local function toggle_winsize()
  if vim.api.nvim_win_get_height(0) < 15 then
    print("maxize")
    vim.api.nvim_win_set_height(0, 100 ) -- maxize window
  else
    print("small")
    vim.api.nvim_win_set_height(0,10) -- small window window
  end
end
local function run_rust()
  -- rustc -C prefer-dynamic <file.rs> -o <bin> && <bin> # dynamic compilation more quickly
  vim.cmd([[w|new|exe "terminal rustc -C prefer-dynamic #:p -o #:p:r && #:p:r"|res 10|%]])
  map_exit("q")
  map_exit("<f5>")
  keymap("n","<f6>",toggle_winsize,opts)
end
local function run_cargo()
  if  vim.fn.expand("%:t") == "main.rs" then
    if vim.fn.expand("%:p:h:t") ~= "src" then
      -- file: bin/pkg/main.rs, compilation target is folder name.
      -- h:parent folder (<parent>/file.ext)
      vim.cmd([[w|new|exe "terminal cargo run --bin #:p:h:t"|res 10|%]])
    else
      -- file: src/main.rs, compilation target is git package name
      vim.cmd([[w|new|exe "terminal cargo run"|res 10|%]])
    end
  else  -- file: bin/pkg.rs, compilation target is name part , 
    -- p:full path , t:tailing part(../<file.ext>) r:remove extension
    vim.cmd([[w|new|exe "terminal cargo run --bin #:t:r"|res 10|%]])
  end
  map_exit("q")
  map_exit("<f6>")
  keymap("n","<f7>",toggle_winsize,opts)
end

keymap("n", "<f5>" , run_rust, {buffer=true})
keymap("n", ":" , "m'A;<esc>``", {buffer=true})
keymap("n", "<f6>", run_cargo,{buffer=true})
