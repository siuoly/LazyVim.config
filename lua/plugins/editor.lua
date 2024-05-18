return {
  {
    "rlue/vim-barbaric",
    event = "InsertEnter",
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader>,",
        "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
        desc = "Switch Buffer",
      },
      { "<leader>/", LazyVim.telescope("live_grep"), desc = "Grep (Root Dir)" },
      { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      { "<leader><space>", LazyVim.telescope("files"), desc = "Find Files (Root Dir)" },
      -- find
      { "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
      { "<leader>fc", LazyVim.telescope.config_files(), desc = "Find Config File" },
      { "<leader>ff", LazyVim.telescope("files"), desc = "Find Files (Root Dir)" },
      { "<leader>fF", LazyVim.telescope("files", { cwd = false }), desc = "Find Files (cwd)" },
      { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Find Files (git-files)" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
      { "<leader>fR", LazyVim.telescope("oldfiles", { cwd = vim.uv.cwd() }), desc = "Recent (cwd)" },
      -- git
      { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Commits" },
      { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Status" },
      -- search
      { '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
      { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics" },
      { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },
      { "<leader>sg", LazyVim.telescope("live_grep"), desc = "Grep (Root Dir)" },
      { "<leader>sG", LazyVim.telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
      { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
      { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
      { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
      { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
      { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
      { "<leader>sw", LazyVim.telescope("grep_string", { word_match = "-w" }), desc = "Word (Root Dir)" },
      { "<leader>sW", LazyVim.telescope("grep_string", { cwd = false, word_match = "-w" }), desc = "Word (cwd)" },
      { "<leader>sw", LazyVim.telescope("grep_string"), mode = "v", desc = "Selection (Root Dir)" },
      { "<leader>sW", LazyVim.telescope("grep_string", { cwd = false }), mode = "v", desc = "Selection (cwd)" },
      { "<leader>uC", LazyVim.telescope("colorscheme", { enable_preview = true }), desc = "Colorscheme with Preview" },
      {
        "<leader>ss",
        function()
          require("telescope.builtin").lsp_document_symbols({
            symbols = require("lazyvim.config").get_kind_filter(),
          })
        end,
        desc = "Goto Symbol",
      },
      {
        "<leader>sS",
        function()
          require("telescope.builtin").lsp_dynamic_workspace_symbols({
            symbols = require("lazyvim.config").get_kind_filter(),
          })
        end,
        desc = "Goto Symbol (Workspace)",
      },
    },
    opts = function()
      local actions = require("telescope.actions")

      local open_with_trouble = function(...)
        return require("trouble.providers.telescope").open_with_trouble(...)
      end
      local open_selected_with_trouble = function(...)
        return require("trouble.providers.telescope").open_selected_with_trouble(...)
      end
      local find_files_no_ignore = function()
        local action_state = require("telescope.actions.state")
        local line = action_state.get_current_line()
        LazyVim.telescope("find_files", { no_ignore = true, default_text = line })()
      end
      local find_files_with_hidden = function()
        local action_state = require("telescope.actions.state")
        local line = action_state.get_current_line()
        LazyVim.telescope("find_files", { hidden = true, default_text = line })()
      end
      return {
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          -- open files in the first window that is an actual file.
          -- use the current window if no other window is available.
          get_selection_window = function()
            local wins = vim.api.nvim_list_wins()
            table.insert(wins, 1, vim.api.nvim_get_current_win())
            for _, win in ipairs(wins) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].buftype == "" then
                return win
              end
            end
            return 0
          end,
          mappings = {
            i = {
              ["<c-t>"] = open_with_trouble,
              ["<a-t>"] = open_selected_with_trouble,
              ["<a-i>"] = find_files_no_ignore,
              ["<a-h>"] = find_files_with_hidden,
              ["<C-Down>"] = actions.cycle_history_next,
              ["<C-Up>"] = actions.cycle_history_prev,
              ["<C-f>"] = actions.preview_scrolling_down,
              ["<C-b>"] = actions.preview_scrolling_up,
              ["<c-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            },
            n = {
              ["<c-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
              ["q"] = actions.close,
            },
          },
        },
      }
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
    opts = {},
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
      { "<C-h>", "<Cmd>NvimTmuxNavigateLeft<cr>", desc = "NvimTmuxNavigateLeft" },
      { "<C-j>", "<Cmd>NvimTmuxNavigateDown<cr>", desc = "NvimTmuxNavigateDown" },
      { "<C-k>", "<Cmd>NvimTmuxNavigateUp<cr>", desc = "NvimTmuxNavigateUp" },
      { "<C-l>", "<Cmd>NvimTmuxNavigateRight<cr>", desc = "NvimTmuxNavigateRight" },
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
    opts = {
      presets = {
        lsp_doc_border = true,
      },
    },
  },
  {
    'MeanderingProgrammer/markdown.nvim',
    -- name = 'render-markdown', -- Only needed if you have another plugin named markdown.nvim
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
        require('render-markdown').setup({
          headings = { 'H1 ', 'H2 ', 'H3 ', 'H4 ', 'H5 ', 'H6 ' },
      })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      source_selector = {
          winbar = true,
          statusline = false
      },
      window = {
        width = 25,
        mappings = {
          ["l"] = "open",
          ["h"] = function(state)
            local node = state.tree:get_node()
              if node.type == 'directory' and node:is_expanded() then
                require'neo-tree.sources.filesystem'.toggle_directory(state, node)
              else
                require'neo-tree.ui.renderer'.focus_node(state, node:get_parent_id())
              end
            end,
          ["dd"] = "delete",
          ["d"] = "none",
          ["<cr>"] = "open_drop",
          ["a"] = { 
            "add", config = {
              show_path = "relative" -- "none", "relative", "absolute"
            }
          },
          ['<tab>'] = function (state)
            local node = state.tree:get_node()
            if require("neo-tree.utils").is_expandable(node) then
              state.commands["toggle_node"](state)
            else
              state.commands['open'](state)
              vim.cmd('Neotree reveal')                  
            end
          end,
        }
      },
      -- buffers = { 
      --   follow_current_file = { 
      --     enabled = true, -- This will find and focus the file in the active buffer every time -- -- the current file is changed while the tree is open.
      --   },
      -- },
      filesystem = {
        commands = {
          -- Override delete to use trash instead of rm
          delete = function(state)
            local path = state.tree:get_node().path
            vim.fn.system({ "rm","-r", vim.fn.fnameescape(path) }) -- trash or rm command
            require("neo-tree.sources.manager").refresh(state.name)
          end,
        },
      --   follow_current_file = {
      --     bind_to_cwd=true,
      --     enabled = false, -- This will find and focus the file in the active buffer every time
      --     --               -- the current file is changed while the tree is open.
      --     leave_dirs_open = true, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
      --   },
      },
    }
  }
}
