return {
  { "nvimdev/dashboard-nvim", enabled = false },
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      on_highlights = function(hl, colors)
        hl.CursorLine = { bg = nil } -- 乾淨
        -- the same: vim.api.nvim_set_hl(0,'CursorLine',{bg=nil})
        hl.Comment = { italic = true, fg = "#727ca7" } --  比較清楚
        hl.DiagnosticUnnecessary = { fg = "#727ca7" } --  比較清楚
        hl["@markup.strong.markdown_inline"] = { bold = true, fg = "#7dcfff" }
        hl["@markup.italic.markdown_inline"] = { italic = true, fg = "#c099ff" }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-storm",
    },
  },
}
