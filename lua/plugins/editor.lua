return {
  {
    "monaqa/dial.nvim",
    opts = function(_, opts)
      local augend = require("dial.augend")
      opts.groups.markdown = {
        augend.misc.alias.markdown_header,
        augend.integer.alias.decimal,
        augend.date.alias["%Y-%m-%d"],
        augend.date.alias["%H:%M"],
      }
      return opts
    end,
  },
  {
    "ziontee113/icon-picker.nvim",
    dependencies = "stevearc/dressing.nvim",
    -- cmd = {"IconPickerNormal"},
    keys = {
      { mode = "i", "<F5>", "<cmd>IconPickerInsert<cr>", desc = "IconPickerInsert" },
    },
    opts = { disable_legacy_commands = true },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },
  {
    "renerocksai/telekasten.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-telekasten/calendar-vim",
    },
    cmd = { "Telekasten" },
    keys = {
      { "<leader>mc", "<cmd>Telekasten show_calendar<CR>", ft = "markdown" },
      { "]]", "<cmd>Telekasten follow_link<CR>", ft = "markdown" },
      { "<leader>mb", "<cmd>Telekasten show_backlinks<CR>", ft = "markdown" },
      { "<leader>t", "<cmd>Telekasten toggle_todo<CR>", ft = "markdown" },
      { mode = "i", "[[", "<cmd>Telekasten insert_link<CR>", ft = "markdown" },
    },
    opts = {
      home = vim.fn.expand("~/Notes/plain/"),
      dailies = vim.fn.expand("~/Notes/plain/" .. os.date("%Y/%m/")),
      weeklies = vim.fn.expand("~/Notes/plain/" .. os.date("%Y/%m/")),
      templates = "/home/siuoly/Notes/plain/templates",
      -- template_new_note = '/path/to/file',    -- template for new notes
      -- template_new_daily = '/path/to/file',   -- template for new daily notes
      -- template_new_weekly = '/path/to/file',  -- template for new weekly notes
    },
  },
  {
    "rlue/vim-barbaric",
    event = "InsertEnter",
  },
  {
    "stevearc/aerial.nvim",
    keys = {
      { "<m-t>", "<cmd>AerialToggle<cr>", desc = "Code outline.[T]oc " },
    },
    -- ft = { "markdown" },
    opts = {
      on_attach = function(bufnr)
        -- Jump forwards/backwards with '{' and '}'
        vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
        vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
      end,
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "danielfalk/smart-open.nvim" },
    },
    cmd = function()
      vim.api.nvim_create_user_command("Toc", "Trouble lsp_document_symbols win.position=right", { nargs = "*" })
    end,
    keys = {
      { "<leader>r", "<Cmd>Telescope live_grep<CR>", desc = "Grep (Root Dir)" },
      { "<leader>p", "<Cmd>Telescope projects<CR>", desc = "Projects" },
      { "<leader><space>", "<cmd>Telescope smart_open<cr>", { noremap = true, silent = true } },
      { "<leader>fp", enabled = false },
      { "<leader>sc", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<c-p>", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>sC", "<cmd>Telescope command_history<cr>", desc = "Command History" },
    },
    opts = function(_, opts)
      local actions = require("telescope.actions")
      local open_with_trouble = function(...)
        return require("trouble.providers.telescope").open_with_trouble(...)
      end
      local open_selected_with_trouble = function(...)
        return require("trouble.providers.telescope").open_selected_with_trouble(...)
      end
      opts.pickers = vim.tbl_deep_extend("force", opts.pickers or {}, {
        live_grep = {
          mappings = {
            i = { ["<c-f>"] = actions.to_fuzzy_refine },
          },
        },
      })
      opts.extensions = vim.tbl_deep_extend("force", opts.extensions or {}, {
        smart_open = { match_algorithm = "fzy" },
      })
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        mappings = {
          i = {
            ["<c-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
          },
          n = {
            ["<c-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            ["<c-t>"] = open_with_trouble,
            ["<a-t>"] = open_selected_with_trouble,
          },
        },
      })
    end,
  },
  {
    "echasnovski/mini.bufremove",
    keys = {
      {
        "Q",
        function()
          require("mini.bufremove").delete(0, true)
        end,
        desc = "Delete Buffer (Force)",
      },
    },
  },
  {
    "nvim-pack/nvim-spectre",
    enabled = false,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    vscode = true,
    ---@type Flash.Config
    opts = { highlight = { backdrop = false, matches = false } },
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, nil },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
  {
    "alexghergh/nvim-tmux-navigation",
    keys = {
      { "<M-h>", "<Cmd>NvimTmuxNavigateLeft<cr>", desc = "NvimTmuxNavigateLeft" },
      { "<M-j>", "<Cmd>NvimTmuxNavigateDown<cr>", desc = "NvimTmuxNavigateDown" },
      { "<M-k>", "<Cmd>NvimTmuxNavigateUp<cr>", desc = "NvimTmuxNavigateUp" },
      { "<M-l>", "<Cmd>NvimTmuxNavigateRight<cr>", desc = "NvimTmuxNavigateRight" },
      { "<C-\\>", "<Cmd>NvimTmuxNavigateLastActive<cr>", desc = "NvimTmuxNavigateLastActive" },
      -- vim.keymap.set("n", "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
    },
    config = function()
      local nvim_tmux_nav = require("nvim-tmux-navigation")
      nvim_tmux_nav.setup({
        -- disable_when_zoomed = true, -- defaults to false
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "latex", -- for makrdown latex
      },
    },
  },
}
