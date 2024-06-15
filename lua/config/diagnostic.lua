-- diagnostic
-- 配置診斷過濾函數
local function set_diagnostics_severity(severity)
  vim.diagnostic.config({
    virtual_text = {
      severity = { min = severity }
    },
    -- float = {
    --   severity = { min = severity }
    -- },
    signs = {
      severity = { min = severity }
    },
    -- underline = {
    --   severity = { min = severity }
    -- },
  })
end

-- 初始化配置為僅顯示 warning 及以上的診斷
set_diagnostics_severity(vim.diagnostic.severity.WARN)

-- 動態改變診斷顯示等級的函數
function ShowDiagnosticsAbove(severity_level)
  set_diagnostics_severity(severity_level)
end

-- 創建命令來調整顯示的診斷等級
vim.cmd [[
  command! -nargs=1 SetDiagnosticSeverity lua ShowDiagnosticsAbove(tonumber(<f-args>))
]]

-- 示例鍵綁定來切換診斷等級
vim.api.nvim_set_keymap('n', '<leader>de', ':lua ShowDiagnosticsAbove(vim.diagnostic.severity.ERROR)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dw', ':lua ShowDiagnosticsAbove(vim.diagnostic.severity.WARN)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>di', ':lua ShowDiagnosticsAbove(vim.diagnostic.severity.INFO)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dh', ':lua ShowDiagnosticsAbove(vim.diagnostic.severity.HINT)<CR>', { noremap = true, silent = true })
