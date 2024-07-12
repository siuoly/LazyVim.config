return{
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
    ---@type lspconfig.options
      servers = {  -- disable linter
        marksman = {
          mason=false,
          enabled=true,
        },
        ruff_lsp = {
          enabled = false,
        },

        pyright = {
          -- 1. 關閉所有 diagnostic
          --   handlers = { 
          --     ["textDocument/publishDiagnostics"] = function() end,
          --   },

          -- 2. TODO: 欲關閉 unused variable, import 等等 diagnostic, 用以下設定
          -- https://www.reddit.com/r/neovim/comments/11k5but/how_to_disable_pyright_diagnostics/
          -- 在此尋找設定檔方法 ~/.local/share/nvim/mason/share/mason-schemas/lsp/pyright.json
          -- format command: :%!jq .
          --
          -- capabilities = (function()
          --   local capabilities = vim.lsp.protocol.make_client_capabilities()
          --   capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 } -- 關閉 neovim hint level
          --   return capabilities
          -- end)(),

          settings = {
            python = {
              analysis = { -- 預設的 reportUnusedImport 爲 none, 改爲其他數值會多出一個診斷
                diagnosticSeverityOverrides = {
                  -- reportUnusedVariable = "warning", -- 自定義
                  -- reportUnusedImport = "information",
                },
                typeCheckingMode = "basic",
              },
            },
          },
        },

      --     markdownlint = {
      --       mason=false,
      --     },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = { },
        python = {},
        json = {"jq"}
      },
      -- linters = {
      --   python={}
      -- }
    },
  },

  --   "ojroques/vim-oscyank",
  --   lazy = false,
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "marksman",
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
        "jq",
      },
    },
  },
}
