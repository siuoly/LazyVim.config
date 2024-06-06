return {
  {
    "rlue/vim-barbaric",
    event = "InsertEnter",
  },
  {
      "vhyrro/luarocks.nvim",
      priority = 1001, -- this plugin needs to run before anything else
      opts = {
          rocks = { "magick" },
      },
  },
  {
      "3rd/image.nvim",
      ft = "markdown",
      opts = {
        integrations = {
          markdown = { enabled = true, },
        },
        editor_only_render_when_focused = false
      },
      dependencies = { "luarocks.nvim" },
  },
  {
      "iamcco/markdown-preview.nvim",
      cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
      ft = { "markdown" },
      build = function() vim.fn["mkdp#util#install"]() end,
  },
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      -- add options here
      -- or leave it empty to use the default settings
      filetypes = {
        markdown = {
          relative_to_current_file=true,
          dir_path="img",
          show_dir_path_in_prompt = true,
          template = "![image]($FILE_PATH)",
        }
      }
    },
    -- keys = {      { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },    },
    commands = {"PasteImage"},
  },
  {
    "hedyhli/markdown-toc.nvim",
    ft = "markdown",  -- Lazy load on markdown filetype
    cmd = { "Mtoc" }, -- Or, lazy load on "Mtoc" command
    opts = {
      -- Your configuration here (optional)
    },
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
    'stevearc/aerial.nvim',
    keys = {
      {"<leader>t","<cmd>AerialOpen<cr>", desc = "Code outline.[T]oc "}
    },
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
      "nvim-tree/nvim-web-devicons"
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "danielfalk/smart-open.nvim" },
    },
      cmd = function()
          vim.api.nvim_create_user_command('Toc', "Trouble lsp_document_symbols win.position=right"
          , { nargs = '*' })
      end,
    keys = {
      { "<leader>r", LazyVim.telescope("live_grep"), desc = "Grep (Root Dir)" },
      { "<leader>p", "<Cmd>Telescope projects<CR>", desc = "Projects" },
      { "<leader><space>", "<cmd>Telescope smart_open<cr>", { noremap = true, silent = true } },
      { "<leader>fp", enabled = false },
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
    "folke/flash.nvim",
    opts = {
      highlight = { backdrop = false, matches = false },
    },
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
    "jbyuki/nabla.nvim",
    ft = "markdown",
    config = function()
      -- require("nabla").toggle_virt({ autogen = true, silient = false })
      vim.keymap.set("n", "<c-p>", require("nabla").popup, { desc = "popup window show formula" })
      vim.api.nvim_create_user_command("NablaToggle", function()
        require("nabla").toggle_virt({ autogen = true, silient = false })
      end, {})
    end,
  },
  {
    "b0o/incline.nvim",
    config = function()
      local helpers = require 'incline.helpers'
      local devicons = require 'nvim-web-devicons'
      require('incline').setup {
        window = {
          padding = 0,
          margin = { horizontal = 0 },
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
          if filename == '' then
            filename = '[No Name]'
          end
          local ft_icon, ft_color = devicons.get_icon_color(filename)
          local modified = vim.bo[props.buf].modified
          return {
            ft_icon and { ' ', ft_icon, ' ', guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or '',
            ' ',
            { filename, gui = modified and 'bold,italic' or 'bold' },
            ' ',
            guibg = '#44406e',
          }
        end,
      }
    end,
    -- Optional: Lazy load Incline
    event = "VeryLazy",
  },
  {
    "MeanderingProgrammer/markdown.nvim",
    enabled = false,
    -- name = 'render-markdown', -- Only needed if you have another plugin named markdown.nvim
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("render-markdown").setup({
        headings = { "H1 ", "H2 ", "H3 ", "H4 ", "H5 ", "H6 " },
      })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      source_selector = {
        statusline = false,
      },
      window = {
        width = 25,
        mappings = {
          ["l"] = "open",
          ["h"] = function(state)
            local node = state.tree:get_node()
            if node.type == "directory" and node:is_expanded() then
              require("neo-tree.sources.filesystem").toggle_directory(state, node)
            else
              require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
            end
          end,
          ["dd"] = "delete",
          ["d"] = "none",
          ["<cr>"] = "open_drop",
          ["a"] = {
            "add",
            config = {
              show_path = "relative", -- "none", "relative", "absolute"
            },
          },
          ["<tab>"] = function(state)
            local node = state.tree:get_node()
            if require("neo-tree.utils").is_expandable(node) then
              state.commands["toggle_node"](state)
            else
              state.commands["open"](state)
              vim.cmd("Neotree reveal")
            end
          end,
        },
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
            vim.fn.system({ "rm", "-r", vim.fn.fnameescape(path) }) -- trash or rm command
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
    },
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
