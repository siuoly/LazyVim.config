return{
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<f5>", function() require('dap').continue() end, desc = "Dap continue" },
      { "<f4>", function() require('dap').toggle_breakpoint() end, desc = "Dap Toggle Breakpoint" },
      { "<f3>", function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, desc = "Dap Lop point message" },
    },
    config = function()
      require("dap-python").setup("python3")
      vim.keymap.set('n', '<F10>', function() require('dap').step_over() end,{desc="Dap Step over"})
      vim.keymap.set('n', '<F11>', function() require('dap').step_into() end,{desc="Dap Step into"})
      vim.keymap.set('n', '<F12>', function() require('dap').step_out() end,{desc="Dap Step out"})
      vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.toggle() end,{desc="Dap Repl Toggle"})
      -- vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end,{desc="Dap Run Last"})
      vim.keymap.set({'n', 'v'}, '<f6>', function()
        require('dap.ui.widgets').hover()
      end,{desc="Dap Hover Variable"})
      vim.keymap.set({'n', 'v'}, '<f7>', function()
        require('dap.ui.widgets').hover(vim.fn.expandcmd("\"shape:\"+repr(<cexpr>.shape)"))
      end,{desc="Dap Hover Shape"})
      vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
        require('dap.ui.widgets').preview()
      end,{desc="Dap Preview"})
      vim.keymap.set('n', '<Leader>df', function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.frames)
      end,{desc="Dap Frame"})
      vim.keymap.set('n', '<Leader>ds', function()
        local widgets = require('dap.ui.widgets')
        widgets.sidebar(widgets.scopes).open()
      end,{desc="Dap Scope Sidebar"})

    vim.api.nvim_create_autocmd("Filetype", {
      pattern="dap-float",
      command=[[nnoremap <buffer> q :q<cr>]],
    })

    local dap_icon = {
      Stopped             = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
      Breakpoint          = {" ","BufferCurrentError"},
      BreakpointCondition = " ",
      BreakpointRejected  = { " ", "DiagnosticError" },
      LogPoint            = ".>",
    }
    for name, sign in pairs(dap_icon) do
      sign = type(sign) == "table" and sign or { sign }
      vim.fn.sign_define(
        "Dap" .. name,
        { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
      )
    end

    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    opts = {

    },
    dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
    config = function (_,opts)
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()

      dap.listeners.before.attach.dapui_config = function() dapui.open() end
      dap.listeners.before.launch.dapui_config = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
    end
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    opts = {
      enabled = true,                        -- enable this plugin (the default)
      enabled_commands = true,               -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
      highlight_changed_variables = true,    -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
      highlight_new_as_changed = false,      -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
      show_stop_reason = true,               -- show stop reason when stopped for exceptions
      commented = false,                     -- prefix virtual text with comment string
      only_first_definition = true,          -- only show virtual text at first definition (if there are multiple)
      all_references = false,                -- show virtual text on all all references of the variable (not only definitions)
      clear_on_continue = false,             -- clear virtual text on "continue" (might cause flickering when stepping)
      --- A callback that determines how a variable is displayed or whether it should be omitted
      --- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
      --- @param buf number
      --- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
      --- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
      --- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
      --- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
      display_callback = function(variable, buf, stackframe, node, options)
        if options.virt_text_pos == 'inline' then
          return ' = ' .. variable.value
        else
          return variable.name .. ' = ' .. variable.value
        end
      end,
      -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
      -- virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',
      virt_text_pos = 'eol',

      -- experimental features:
      all_frames = false,                    -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
      virt_lines = false,                    -- show virtual lines instead of virtual text (will flicker!)
      virt_text_win_col = nil                -- position the virtual text at a fixed window column (starting from the first text column) ,
    },
  },
  --TODO:
  --檢查有效性, 其他lib是否仍保留
  {
     "folke/lazydev.nvim",
    opts = {
      library = { plugins = { "nvim-dap-ui" }, types = true },
    }
  },
  {
    "Weissle/persistent-breakpoints.nvim",
    opts = {
      load_breakpoints_event = { "BufReadPost" },
      -- save_dir = vim.fn.stdpath('data') .. '/nvim_checkpoints',
    },
    config = function(_,opts)
      vim.keymap.set("n", "<f4>", "<cmd>lua require('persistent-breakpoints.api').toggle_breakpoint()<cr>")
      -- keymap("n", "<YourKey2>", "<cmd>lua require('persistent-breakpoints.api').set_conditional_breakpoint()<cr>", opts)
      -- keymap("n", "<YourKey3>", "<cmd>lua require('persistent-breakpoints.api').clear_all_breakpoints()<cr>", opts)
      require 'persistent-breakpoints'.setup( opts)
    end
  }
}
