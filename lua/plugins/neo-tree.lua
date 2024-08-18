return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      {
        "<c-n>",
        function()
          if vim.b.neo_tree_source == "filesystem" then
            require("neo-tree.command").execute({ action = "close" })
          else
            require("neo-tree.command").execute({ focus = true, dir = LazyVim.root() })
          end
        end,
        desc = "Explorer NeoTree (Root Dir)",
        remap = true,
      },
    },
    opts = function(_, opts)
      -- opts.filesystem.follow_current_file= {
      --   enabled = false,       -- automatically exapnd directory
      --   leave_dirs_open = true, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
      -- }
      opts.filesystem.bind_to_cwd = true
      opts.filesystem.commands = {
        trash = function(state)
          local path = state.tree:get_node().path
          vim.fn.system({ "trash", vim.fn.fnameescape(path) })
          require("neo-tree.sources.manager").refresh(state.name)
        end,
      }
      opts.window.mappings = vim.tbl_extend("force", opts.window.mappings, {
        ["<c-s>"] = "open_split",
        ["<c-v>"] = "open_vsplit",
        ["s"] = "noop",
        ["S"] = "noop",
        ["<tab>"] = "next_source",
        ["<s-tab>"] = "prev_source",
      })

      local fc = require("neo-tree.sources.filesystem.commands")
      local fi = require("neo-tree.sources.filesystem")
      opts.filesystem.window = {
        mappings = {
          ["d"] = "noop",
          ["dd"] = "trash",
          ["/"] = "noop",
          ["s"] = "fuzzy_finder",
          ["."] = "noop",
          ["<c-]>"] = "set_root",
          ["h"] = {
            function(state)
              local node = state.tree:get_node()
              if node.type == "directory" and node:is_expanded() then
                fi.toggle_directory(state, node)
              else
                require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
              end
            end,
            desc = "go parent or close directory",
          },
          ["l"] = {
            function(state)
              local node = state.tree:get_node()
              if node.type == "directory" then
                if not node:is_expanded() then
                  fi.toggle_directory(state, node)
                elseif node:has_children() then
                  require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
                end
              else
                fc.open(state)
              end
            end,
            desc = "open or toggle directory",
          },
          ["<cr>"] = {
            function(state)
              fc.open(state)
              if state.tree:get_node().type ~= "directory" then
                require("neo-tree.sources.common.commands").close_window(state)
              end
            end,
            desc = "open and close tree",
          },
        },
      }
      opts.enable_diagnostics = false
      opts.default_component_configs.git_status = {
        symbols = {
          unstaged = "",
          staged = "",
        },
      }
    end,
  },
}
