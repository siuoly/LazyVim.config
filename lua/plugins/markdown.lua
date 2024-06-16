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
}
