return {
  {
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = "LazyFile",
    opts = {
      -- symbol = "▏",
      symbol = "│",
      options = { try_as_border = true },
      draw = {
        animation = function()
          return 0
        end,
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
          "NvimTree",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
  {
    "b0o/incline.nvim",
    config = function()
      local devicons = require("nvim-web-devicons")
      require("incline").setup({
        window = {
          padding = 0,
          margin = { horizontal = 0 },
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if filename == "" then
            filename = "[No Name]"
          end
          local ft_icon, ft_color = devicons.get_icon_color(filename)

          local function get_file_name()
            local label = {}
            table.insert(label, { (ft_icon or "") .. " ", guifg = ft_color, guibg = "none" })

            table.insert(label, { filename, gui = vim.bo[props.buf].modified and "italic,underline" or "normal" })
            -- table.insert(label, { modified and " ● " or "   ", guifg = modified and "#9ece6a" or "none" })
            if not props.focused then
              label["group"] = "BufferInactive"
            end
            return label
          end
          return {
            { get_file_name() },
            guibg = "none", -- "#44406e" gray coloer,
          }
        end,
      })
    end,
    -- Optional: Lazy load Incline
    event = "VeryLazy",
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections.lualine_z = {} -- disable time show
      return opts
    end,
  },
}
