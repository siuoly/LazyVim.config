return {
  {
    "monaqa/dial.nvim",
    opts = function(_, opts)
      local augend = require("dial.augend")
      opts.groups.markdown = {
        augend.misc.alias.markdown_header,
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
    "stevearc/overseer.nvim",
    keys = {
      { "<F5>", "<cmd>OverseerRun<cr>", desc = "Run task" },
      { "<F6>", "<cmd>OverseerToggle<cr>", desc = "Task list" },
    },
    opts = {
      templates = { "builtin", "user.python_run" },
      task_list = {
        bindings = {
          ["r"] = "<CMD>OverseerQuickAction restart<CR>",
          ["<C-h>"] = false,
          ["<C-j>"] = false,
          ["<C-k>"] = false,
          ["<C-l>"] = false,
        },
      },
    },
  },
  {
    "michaelb/sniprun",
    branch = "master",
    build = "sh install.sh",
    -- do 'sh install.sh 1' if you want to force compile locally
    -- (instead of fetching a binary from the github release). Requires Rust >= 1.65
    keys = {
      { mode = "x", "<cr>", "<Plug>SnipRun", { silent = true } },
      { "<s-cr>", "<Plug>SnipRun<cr>", { silent = true } },
    },
    config = function()
      require("sniprun").setup({
        selected_interpreters = { "Python3_fifo" },
        repl_enable = { "Python3_fifo" },
        display = {
          -- "Classic",                    --# display results in the command-line  area
          "VirtualTextOk", --# display ok results as virtual text (multiline is shortened)

          -- "VirtualText",             --# display results as virtual text
          "TempFloatingWindow", --# display results in a floating window
          "LongTempFloatingWindow", --# same as above, but only long results. To use with VirtualText[Ok/Err]
          -- "Terminal",                --# display results in a vertical split
          -- "TerminalWithCode",        --# display results and code history in a vertical split
          -- "NvimNotify",              --# display with the nvim-notify plugin
          -- "Api"                      --# return output to a programming interface
        },
      })
    end,
  },
  {
    "rlue/vim-barbaric",
    event = "InsertEnter",
  },
  {
    "danielfalk/smart-open.nvim",
    branch = "0.2.x",
    config = function()
      require("lazyvim.util").on_load("telescope.nvim", function()
        require("telescope").load_extension("smart_open")
      end)
    end,
    keys = {
      -- {"<leader><space>","<cmd>Telescope smart_open<cr>", {noremap=true,silent=true}}
    },
    dependencies = {
      "kkharji/sqlite.lua",
      -- Only required if using match_algorithm fzf
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      -- Optional.  If installed, native fzy will be used when match_algorithm is fzy
      { "nvim-telescope/telescope-fzy-native.nvim" },
    },
  },
  {
    "stevearc/aerial.nvim",
    keys = {
      { "<m-t>", "<cmd>AerialToggle<cr>", desc = "Code outline.[T]oc " },
    },
    ft = { "markdown" },
    opts = {
      on_attach = function(bufnr)
        -- Jump forwards/backwards with '{' and '}'
        vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
        vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
      end,
    },
    -- Optional dependencies
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
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
    "jpalardy/vim-slime",
    ft = "python",
    config = function()
      vim.cmd([[
        let g:slime_config_defaults = get(g:,"slime_config_defaults",{})
        let g:slime_config_defaults["python_ipython"] = 0
        let g:slime_config_defaults["dispatch_ipython_pause"] = 100

        function! _EscapeText_python(text)
          if slime#config#resolve("python_ipython") && len(split(a:text,"\n")) > 1
            return ["%cpaste -q\n", slime#config#resolve("dispatch_ipython_pause"), a:text, "--\n"]
          else
            let empty_lines_pat = '\(^\|\n\)\zs\(\s*\n\+\)\+'
            let no_empty_lines = substitute(a:text, empty_lines_pat, "", "g")
            let dedent_pat = '\(^\|\n\)\zs'.matchstr(no_empty_lines, '^\s*')
            let dedented_lines = substitute(no_empty_lines, dedent_pat, "", "g")
            let except_pat = '\(elif\|else\|except\|finally\)\@!'
            let add_eol_pat = '\n\s[^\n]\+\n\zs\ze\('.except_pat.'\S\|$\)'
            return substitute(dedented_lines, add_eol_pat, "\n", "g")
          end
        endfunction
      ]])
      vim.g.slime_target = "tmux"
      -- vim.g.slime_default_config = {"socket_name" = "default", "target_pane" = "{last}"}
      vim.g.slime_default_config = {
        -- Lua doesn't have a string split function!
        socket_name = vim.api.nvim_eval('get(split($TMUX, ","), 0)'),
        target_pane = "{top-right}",
      }
    end,
  },
  {
    "folke/noice.nvim", -- https://github.com/LazyVim/LazyVim/issues/556 add border on Preview window
    -- enabled = false,
    opts = function(_, opts)
      opts.presets = vim.tbl_deep_extend("force", opts.presets or {}, {
        lsp_doc_border = true,
      })
      opts.lsp = vim.tbl_deep_extend("force", opts.lsp or {}, {
        signature = {
          enabled = true,
          auto_open = {
            enabled = false,
            trigger = false, -- Automatically show signature help when typing a trigger character from the LSP
            luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
            throttle = 50, -- Debounce lsp signature help request by 50ms
          },
        },
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
