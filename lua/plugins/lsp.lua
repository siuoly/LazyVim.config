return{
  {
    "neovim/nvim-lspconfig",
    -- ---@class PluginLspOpts
    -- opts = {
    --   ---@type lspconfig.options
    --   servers = {  -- disable linter
    --     marksman = {
    --       mason=false,
    --     },
    --     markdownlint = {
    --       mason=false,
    --     },
    --   },
    -- },
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = { },
      },
    },
  },
}
