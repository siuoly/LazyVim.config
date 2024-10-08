return {
  {
    "nvim-tree/nvim-tree.lua",
    enabled=false,
    keys = function(_)
      ----------------- open nvim-tree at current file buffer
      local function open_nvim_tree_at_current_buffer()
        local current_buffer_path = vim.fn.expand("%:p:h") -- 獲取當前 buffer 的目錄
        api.tree.change_root(current_buffer_path) -- 更改 nvim-tree 的根目錄
        api.tree.open() -- 打開 nvim-tree
      end
      ----------------- open nvim-tree toggle or focus on it
      local nvimTreeFocusOrToggle = function()
        local nvimTree = require("nvim-tree.api")
        local currentBuf = vim.api.nvim_get_current_buf()
        local currentBufFt = vim.api.nvim_get_option_value("filetype", { buf = currentBuf })
        if currentBufFt == "NvimTree" then
          nvimTree.tree.toggle()
        else
          nvimTree.tree.focus()
        end
      end
      return {
        { "<c-n>", nvimTreeFocusOrToggle, { desc = "nvimTree Focus Or Toggle" } },
        { "<leader>E", open_nvim_tree_at_current_buffer, { noremap = true, silent = true } },
      }
    end,
    config = function()
      ----------------- exit directly without leaving nvim-tree buffer
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("NvimTreeClose", { clear = true }),
        pattern = "NvimTree_*",
        callback = function()
          local layout = vim.api.nvim_call_function("winlayout", {})
          if
            layout[1] == "leaf"
            and vim.api.nvim_get_option_value("filetype", { buf = vim.api.nvim_win_get_buf(layout[2]) }) == "NvimTree"
            and layout[3] == nil
          then
            vim.cmd("confirm quit")
          end
        end,
      })

      local nvim_tree = require("nvim-tree")
      local api = require("nvim-tree.api")

      local function close_or_go_parent()
        local node = api.tree.get_node_under_cursor()
        if node.name == ".." then -- 行首 root
          vim.cmd.normal("j")
          api.tree.change_root_to_parent()
          vim.cmd.normal("k")
        elseif node.nodes ~= nil and node.open == true then -- 资料夹 以开
          api.node.navigate.parent_close()
        else
          api.node.navigate.parent() -- 档案 or 资料夹未开
        end
      end

      nvim_tree.setup({
        on_attach = function(bufnr)
          local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end
          api.config.mappings.default_on_attach(bufnr)
          vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
          vim.keymap.set("n", "h", close_or_go_parent, opts("GO UP"))
          vim.keymap.set("n", "l", api.node.open.edit, opts("Edit"))
          vim.keymap.set("n", "<cr>", function()
            api.node.open.edit()
            api.tree.close()
          end, opts("Edit"))
          vim.keymap.set("n", "o", api.node.open.edit, opts("Edit"))
          vim.keymap.set("n", "H", api.tree.collapse_all, opts("Collapse All"))
          vim.keymap.set("n", ".", function()
            api.tree.change_root(vim.uv.cwd())
          end, opts("go to cwd"))

          vim.keymap.set("n", "dd", api.fs.trash, opts("Trash"))
          vim.keymap.set("n", "d", function() end, opts(""))
          vim.keymap.set("n", "D", function() end, opts(""))
        end,

        -- update_cwd = true,
        -- update_focused_file = {
        --   enable = false,
        --   update_cwd = false,
        --   update_root = true,
        -- },
        filters = {
          custom = { "^.git$" },
          dotfiles = false, -- show dot files
        },

        disable_netrw = true,
        hijack_netrw = true,
        hijack_cursor = true,
        hijack_unnamed_buffer_when_opening = false,
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = true,
        },

        ui = {
          confirm = {
            remove = false,
            trash = false,
          },
        },
        live_filter = {
          prefix = "[FILTER]: ",
          always_show_folders = false, -- Turn into false from true by default
        },
        git = {
          enable = true,
          ignore = true,
        },
        filesystem_watchers = {
          enable = true,
        },
        actions = {
          open_file = {
            resize_window = true,
          },
        },
        renderer = {

          root_folder_label = ":~:s?$?/",
          highlight_git = true,
          highlight_opened_files = "none",

          indent_markers = {
            enable = true,
          },
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
            git_placement = "after",
            glyphs = {
              default = "",
              symlink = "",
              folder = {
                arrow_open = "",
                arrow_closed = "",
                default = "",
                open = "",
                empty = "",
                empty_open = "",
                symlink = "",
                symlink_open = "",
              },
              git = {
                unstaged = "✗",
                staged = "✓",
                unmerged = "",
                renamed = "➜",
                untracked = "U",
                deleted = "",
                ignored = "◌",
              },
            },
          },
        },
        diagnostics = {
          enable = false,
          show_on_dirs = true,
          icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
          },
        },
        view = {
          adaptive_size = false,
          side = "left",
          width = 30,
          preserve_window_proportions = true,
        },
      })
    end,
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
}
