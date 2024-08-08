-- 定義一個全局變量來存儲窗口ID
local win_id = nil

-- 顯示浮動窗口的函數
local function ShowFloatingWindow(content)
  -- 創建一個新的 buffer
  content = content[1]

  local buf = vim.api.nvim_create_buf(false, true)

  -- 設置 buffer 的內容
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { content })

  -- 設置浮動窗口的大小和位置
  local win_height = math.ceil(#content / 40)
  local win_width = math.min(40, #content) -- 固定寬度為 40

  -- 浮動窗口的選項
  local opts = {
    style = "minimal",
    relative = "cursor",
    row = 1,
    col = 1,
    width = win_width,
    height = win_height,
    border = "single", -- 這是邊框的樣式
  }

  -- 創建浮動窗口
  win_id = vim.api.nvim_open_win(buf, false, opts)

  -- 設置窗口選項, buffer選項
  vim.api.nvim_set_option_value("wrap", true, { win = win_id })
  vim.api.nvim_set_option_value("linebreak", false, { win = win_id })
  vim.api.nvim_set_option_value("scrolloff", 1, { win = win_id })
  vim.keymap.set("n", "q", ":q<cr>", { buffer = buf, silent = true })

  -- 設置自動命令，在游標移動時關閉窗口
  vim.api.nvim_create_autocmd("CursorMoved", {
    buffer = 0,
    once = true,
    callback = function()
      if win_id and vim.api.nvim_win_is_valid(win_id) then
        vim.api.nvim_win_close(win_id, true)
        win_id = nil
      end
    end,
  })
end

-- 異步執行命令並顯示浮動窗口
local function ExecuteCommandAndShowWindow(cmd)
  -- 執行異步命令
  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data, _)
      -- 當命令完成後的回調
      if data then
        ShowFloatingWindow(data)
      end
    end,
    on_stderr = function(_, data, _)
      if data then
        vim.notify(table.concat(data, "\n"), vim.log.levels.ERROR)
      end
    end,
  })
end

local function add_quote(content)
  content = string.gsub(content, "[\r\n]", "")
  if not (content:sub(1, 1) == '"') then
    content = '"' .. content
  end
  if not (content:sub(-1) == '"') then
    content = content .. '"'
  end
  return content
end

local function CopyAndTranslatedSentence()
  vim.cmd.normal("y")
  local content = add_quote(vim.fn.getreg('"'))
  ExecuteCommandAndShowWindow("trans -b :zh-TW " .. content)
  vim.cmd.normal("gv")
end

-- 綁定按鍵來調用這個函數
local opt = { noremap = true, silent = true }
vim.keymap.set("x", "<c-j>", CopyAndTranslatedSentence, {})

local function pronounce_select()
  vim.cmd.normal("y")
  local content = add_quote(vim.fn.getreg('"'))
  vim.system({ "trans", "-sp", "-b", content })
  vim.cmd.normal("gv")
end

local function dict_search_word()
  -- sdcv:dictionary command
  -- grep:color output command
  vim.api.nvim_command([[terminal sdcv <cword>|grep --color=always -zP -e "-->.*\n"]])
  vim.cmd("tab split")
  vim.keymap.set("n", "q", ":bd!<cr>", { buffer = true, nowait = true })
end

local function pronounce_word()
  vim.system({ "trans", "-sp", "-b", vim.fn.expand("<cword>") })
  vim.cmd.normal("gv")
end

local map = vim.keymap.set
map("n", "gss", dict_search_word, { desc = "sdcv dictionary search keyword" })
map("n", "<c-h>", pronounce_word, { desc = "Pronounce the word under cursor" })
map("x", "<c-h>", pronounce_select, { desc = "Pronounce the selected word.", silent = true })

-- introduce a self-correlated learning mechanism自相關學習機制 to exploit the non-local relationship in the preliminary information(初步資訊) fusion space among samples(樣本之間融合空間中).considers the sample correlation in both the perspective of the local and global level
-- debug
-- 1. CopyAndRunCommand
-- cmd = [[ trans -b :zh-TW "Kitty terminal also has a unicode selector. I found this to be way more easily exploreable than then nerd fonts cheat sheet, and I think Kitty's unicode input lists more icons, too. Of course, you'd need to be using Kitty for that." ]]
-- ExecuteCommandAndShowWindow(cmd)
