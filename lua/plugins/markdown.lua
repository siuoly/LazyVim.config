return {
  -- {
  --     "vhyrro/luarocks.nvim",
  --     priority = 1001, -- this plugin needs to run before anything else
  --     opts = {
  --         rocks = { "magick" },
  --     },
  -- },
  -- {
  --     "3rd/image.nvim",
  --     ft = "markdown",
  --     opts = {
  --       integrations = {
  --         markdown = { enabled = true, },
  --       },
  --       editor_only_render_when_focused = false
  --     },
  --     dependencies = { "luarocks.nvim" },
  -- },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      -- add options here
      -- or leave it empty to use the default settings
      filetypes = {
        markdown = {
          relative_to_current_file = true,
          dir_path = "img",
          show_dir_path_in_prompt = true,
          template = "![image]($FILE_PATH)",
        },
      },
    },
    -- keys = {      { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },    },
    commands = { "PasteImage" },
  },
  {
    "jbyuki/nabla.nvim",
    enabled = false,
    ft = "markdown",
    keys = {
      { "<c-p>", '<Cmd>lua require("nabla").popup()<cr>', ft = "markdown", desc = "popup window show formula" },
    },
    config = function()
      -- require("nabla").toggle_virt({ autogen = true, silient = false })
      -- vim.keymap.set("n", "<c-p>", require("nabla").popup, { desc = "popup window show formula" })
      vim.api.nvim_create_user_command("NablaToggle", function()
        require("nabla").toggle_virt({ autogen = true, silient = false })
      end, {})
    end,
  },
  {
    "MeanderingProgrammer/markdown.nvim",
    enabled = true,
    opts = {
      file_types = { "markdown", "norg", "rmd", "org" },
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
    anti_conceal = {
        -- This enables hiding any added text on the line the cursor is on
        -- This does have a performance penalty as we must listen to the 'CursorMoved' event
        enabled = false,
    },
      heading = {
        sign = true,
        icons = {},
        -- disable backgrounds
        backgrounds = { "", "", "", "", "", "", },
      },
      link = {
        enabled = false,
      },
      render_modes = {'V',  'v', 'n', 'c','i','no' },
    win_options = {
        -- See :h 'conceallevel'
        conceallevel = {
            default = vim.api.nvim_get_option_value('conceallevel', {}),
            rendered = 0,
        },
        concealcursor = {
            -- Used when not being rendered, get user setting
            default = vim.api.nvim_get_option_value('concealcursor', {}),
            -- Used when being rendered, disable concealing text in all modes
            rendered = '',
        },
      },
    },
    ft = { "markdown", "norg", "rmd", "org" },
  },
}
