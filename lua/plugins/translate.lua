return {
  {
    -- NOTE:
    -- pacman -S sqlite
    -- pacman -S festival festival-us # or festival-english
    -- edit file ~/.festivalrc, add following
    -- ```
    -- (Parameter.set 'Audio_Required_Format 'aiff)
    -- (Parameter.set 'Audio_Method 'Audio_Command)
    -- (Parameter.set 'Audio_Command "paplay $FILE --client-name=Festival --stream-name=Speech")
    -- ```
    --
    "JuanZoran/Trans.nvim",
    enabled = vim.fn.hostname() == "arch-x260",
    keys = {
      -- 可以换成其他你想映射的键
      { "<c-j>", mode = "n", "<Cmd>Translate<CR>", desc = "󰊿 Translate" },
      -- { 'mk', mode = { 'n', 'x' }, '<Cmd>TransPlay<CR>', desc = ' Auto Play' },
      -- 目前这个功能的视窗还没有做好，可以在配置里将view.i改成hover
      -- { 'mi', '<Cmd>TranslateInput<CR>', desc = '󰊿 Translate From Input' },
    },
    dependencies = { "kkharji/sqlite.lua" },
    -- 查看 字典目錄
    -- 加入字尾
    -- 用訊息展示
    opts = {
      ---@type 'default' | 'dracula' | 'tokyonight' global Trans theme [see lua/Trans/style/theme.lua]
      theme = "tokyonight", -- default | tokyonight | dracula
      strategy = {
        ---@type { frontend:string, backend:string | string[] } fallback strategy for mode
        default = {
          frontend = "hover",
          backend = "*",
        },
      },
      ---@type table frontend options
      frontend = {
        ---@class TransFrontendOpts
        ---@field keymaps table<string, string>
        default = {
          query = "fallback",
          border = "rounded",
          title = vim.fn.has("nvim-0.9") == 1 and {
            { "", "TransTitleRound" },
            { " Trans", "TransTitle" },
            { "", "TransTitleRound" },
          } or nil, -- need nvim-0.9+
          auto_play = false,
          ---@type {open: string | boolean, close: string | boolean, interval: integer} Hover Window Animation
          animation = {
            open = "fold", -- 'fold', 'slid'
            close = "fold",
            interval = 0,
            a, -- 關動畫
          },
          timeout = 2000,
        },
        ---@class TransHoverOpts : TransFrontendOpts
        hover = {
          ---@type integer Max Width of Hover Window
          width = 37,
          ---@type integer Max Height of Hover Window
          height = 27,
          ---@type string -- see: /lua/Trans/style/spinner
          spinner = "dots",
          ---@type string
          fallback_message = "{{notfound}} 翻译超时或没有找到相关的翻译",
          auto_resize = true,
          split_width = 60,
          padding = 10, -- padding for hover window width
          keymaps = {
            pageup = "[[",
            pagedown = "]]",
            pin = "<leader>[",
            close = "<leader>]",
            toggle_entry = "<leader>;",
            -- play         = '_', -- Deprecated
          },
          ---@type string[] auto close events
          auto_close_events = {
            "InsertEnter",
            "CursorMoved",
            "BufLeave",
          },
          ---@type table<string, string[]> order to display translate result
          order = {
            default = {
              "str",
              "translation",
              "definition",
            },
            offline = {
              "title",
              "tag",
              "pos",
              "exchange",
              "translation",
              "definition",
            },
            youdao = {
              "title",
              "translation",
              "definition",
              "web",
            },
          },
          icon = {
            -- or use emoji
            list = "●", -- ● | ○ | ◉ | ◯ | ◇ | ◆ | ▪ | ▫ | ⬤ | 🟢 | 🟡 | 🟣 | 🟤 | 🟠| 🟦 | 🟨 | 🟧 | 🟥 | 🟪 | 🟫 | 🟩 | 🟦
            star = "", -- ⭐ | ✴ | ✳ | ✲ | ✱ | ✰ | ★ | ☆ | 🌟 | 🌠 | 🌙 | 🌛 | 🌜 | 🌟 | 🌠 | 🌌 | 🌙 |
            notfound = " ", --❔ | ❓ | ❗ | ❕|
            yes = "✔", -- ✅ | ✔️ | ☑
            no = "", -- ❌ | ❎ | ✖ | ✘ | ✗ |
            cell = "■", -- ■  | □ | ▇ | ▏ ▎ ▍ ▌ ▋ ▊ ▉
            web = "󰖟", --🌍 | 🌎 | 🌏 | 🌐 |
            tag = "",
            pos = "",
            exchange = "",
            definition = "󰗊",
            translation = "󰊿",
          },
        },
      },
    },
    config = function(_, opts)
      require("Trans").setup(opts)
      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = {"Trans"},
        callback = function()
          vim.keymap.set("n","q","<cmd>q<cr>",{desc = "Exit Trans window",buffer = true,})
        end,
      })
    end,
  },
}
