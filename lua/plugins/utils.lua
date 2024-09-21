return {
  {
    "MaximilianLloyd/lazy-reload.nvim",
    lazy = false,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    keys = {
      { "<leader>r", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
    },
  },
  {
    "stevearc/overseer.nvim",
    keys = {
      { "<F5>", "<cmd>w<cr><cmd>OverseerRun build_and_run<cr>", desc = "Save and Overseer run task" },
      { "<F6>", "<cmd>w<cr><cmd>OverseerRun build<cr>", desc = "Save and Overseer build task" },
    },
    opts = {
      templates = { "builtin", "user.rust_build", "user.rust_build_and_run", "user.python_run", "user.rust_run" },
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
}
