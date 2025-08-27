local icons = require('helpers.icons')
local keymaps = require('plugins.coding.dap.keymaps')

--------------------------------------------------------------------------------------

local function dapConfig()
  -- use overseer for running preLaunchTask and postDebugTask
  require('overseer').enable_dap()

  -- require('dap.ext.vscode').load_launchjs('launch.json')
  -- require('dap.ext.vscode').load_launchjs(nil, { node = { 'typescript', 'javascript' } })
  require('dap.ext.vscode').json_decode = require('overseer.json').decode
  --
  -- -- AUTO-OPEN/CLOSE THE DAP-UI
  -- local listener = require('dap').listeners.before
  -- listener.attach.dapui_config = function()
  --   require('dapui').open()
  -- end
  -- listener.launch.dapui_config = function()
  --   require('dapui').open()
  -- end
  -- listener.event_terminated.dapui_config = function()
  --   require('dapui').close()
  -- end
  -- listener.event_exited.dapui_config = function()
  --   require('dapui').close()
  -- end

  require('plugins.coding.dap.typescript')
  -- require("config.dap.cs").setup()

  vim.keymap.set('n', '<leader>tm', function()
    if vim.api.nvim_buf_get_option_value('filetype', { buf = 0 }) == 'java' then
      require('jdtls').test_nearest_method()
    end
  end)

  vim.api.nvim_create_user_command(
    'DebugRemoteProcess',
    require('plugins.coding.dap.custom-action').attach_to_remote_debugger,
    {}
  )
end

return {
  {
    'mfussenegger/nvim-dap',
    event = 'VeryLazy',
    keys = keymaps.dap_keymaps(),
    dependencies = {
      { 'theHamsta/nvim-dap-virtual-text', opts = { virt_text_pos = 'eol' } },
    },
    init = function()
      vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#993939', bg = '#31353f' })
      vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef', bg = '#31353f' })
      vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379', bg = '#31353f' })

      -- vim.fn.sign_define('DapStopped', { text = icons.dap.Stopped, texthl = 'DiagnosticHint', linehl = 'DapPause' })
      -- vim.fn.sign_define('DapBreakpointRejected', { text = icons.dap.BreakpointRejected, texthl = 'DiagnosticError' })

      --
      vim.fn.sign_define(
        'DapBreakpoint',
        { text = icons.dap.Breakpoint, texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' }
      )
      vim.fn.sign_define(
        'DapBreakpointCondition',
        { text = '󰟃', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' }
      )
      vim.fn.sign_define(
        'DapBreakpointRejected',
        { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' }
      )
      vim.fn.sign_define(
        'DapLogPoint',
        { text = '', texthl = 'DapLogPoint', linehl = 'DapLogPoint', numhl = 'DapLogPoint' }
      )
      vim.fn.sign_define(
        'DapStopped',
        { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' }
      )
    end,
    config = dapConfig,
  },

  { -- fancy UI for the debugger
    'rcarriga/nvim-dap-ui',
    event = 'VeryLazy',
    dependencies = { 'nvim-neotest/nvim-nio' },
    keys = keymaps.dap_ui_keymaps(),
    opts = {
      element_mappings = {
        scopes = { open = '<CR>', edit = 'e', expand = 'o', repl = 'r' },
      },
      force_buffers = true,
      icons = {
        expanded = icons.ui.TriangleShortArrowDown,
        current_frame = icons.ui.CurrentFrame,
        collapsed = icons.ui.TriangleShortArrowRight,
      },
      layouts = {
        {
          elements = {
            { id = 'repl', size = 0.4 },
            { id = 'scopes', size = 0.6 },
          },
          position = 'bottom',
          size = 15,
        },
      },
      floating = {
        border = vim.g.borderStyle,
        mappings = {
          close = { 'q', '<Esc>' },
        },
      },
      render = {
        max_type_length = nil,
        indent = 2,
        max_value_lines = 100,
      },
    },
    config = function(_, opts)
      local dap, dapui = require('dap'), require('dapui')
      dapui.setup(opts)
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      -- Listen for the initialization completion event to ensure that the UI is opened only after a successful connection
      dap.listeners.after.event_initialized.dapui_config = function()
        dapui.open({ reset = true })
      end

      -- Listening for disconnect events
      dap.listeners.before.disconnect.dapui_config = function()
        dapui.close()
      end

      -- Listen for error events and close the UI if startup fails
      dap.listeners.after.event_output.dapui_config = function(_, body)
        if body.category == 'stderr' and body.output:match('Error') then
          vim.defer_fn(function()
            if not dap.session() then
              dapui.close()
            end
          end, 500)
        end
      end

      -- Unified handling of all events that may affect the dap-ui layout
      local group = vim.api.nvim_create_augroup('DapUILayoutManager', { clear = true })

      -- Listening for window change events
      vim.api.nvim_create_autocmd({ 'WinClosed', 'WinNew', 'VimResized' }, {
        group = group,
        callback = function()
          if dap.session() then
            -- Use schedule to ensure execution in the next event loop
            vim.schedule(function()
              dapui.open({ reset = true })
            end)
          end
        end,
      })
    end,
  },

  { -- mason.nvim integration
    'jay-babu/mason-nvim-dap.nvim',
    event = 'VeryLazy',
    dependencies = 'mason.nvim',
    cmd = { 'DapInstall', 'DapUninstall' },
    opts = {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_setup = true,
      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},
      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
      },
    },
  },
  --  Debugging with go debugger
  {
    'leoluz/nvim-dap-go',
    event = 'VeryLazy',
    config = function()
      require('dap-go').setup({
        dap_configurations = {
          {
            type = 'go',
            name = 'Debug (Main) Package',
            request = 'launch',
            program = 'main.go',
            cwd = '${workspaceFolder}',
          },
          {
            type = 'go',
            name = "Delve: debug opened file's cmd/cli",
            request = 'launch',
            cwd = '${fileDirname}', -- FIXME: should work from repo root
            program = './${relativeFileDirname}',
            args = {},
          },
          {
            type = 'go',
            name = 'Delve: debug test (manually enter test name)',
            request = 'launch',
            mode = 'test',
            program = './${relativeFileDirname}',
            args = function()
              local testname = vim.fn.input('Test name (^regexp$ ok): ')
              return { '-test.run', testname }
            end,
          },
        },
      })
    end,
  },
  -- [persistent-breakpoints.nvim] - Store breakpoints location on disk and load them on buffer open event.
  -- See: `:h persistent-breakpoints.nvim`
  -- link: https://github.com/Weissle/persistent-breakpoints.nvim
  {
    'Weissle/persistent-breakpoints.nvim',
    branch = 'main',
    -- keys = keymaps.persistent_keymaps(),
    opts = {
      save_dir = vim.fn.stdpath('cache') .. '/nvim_breakpoints',
      load_breakpoints_event = { 'BufReadPost' },
      perf_record = false,
      on_load_breakpoint = nil,
    },
    config = function(_, opts)
      require('persistent-breakpoints').setup(opts)
    end,
  },
}
