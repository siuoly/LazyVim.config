return {
  name = "Run Rust",
  builder = function()
    local cmd = vim.fn.expand("%:p:r")
    return {
      cmd = cmd,
      args = {},
      -- default_component_params = {
      --     errorformat = set_efm(vim.bo.filetype),
      -- },
      components = {
        "default",
        "open_output",
        -- { 'on_output_quickfix', open = true },
      },
    }
  end,
  condition = {
    filetype = { "rust" },
  },
}
