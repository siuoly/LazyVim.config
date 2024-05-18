return {
  --   "ojroques/vim-oscyank",
  --   lazy = false,
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
        "jq",
      },
    },
  },
}
