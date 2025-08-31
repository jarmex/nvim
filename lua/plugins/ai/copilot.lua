return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    -- event = 'InsertEnter',
    keys = { { '<leader>cp', ':Copilot<CR>', desc = 'Copilot' } },
    build = ':Copilot auth',
    opts = {
      panel = { enabled = false },
      server_opts_overrides = {
        settings = {
          telemetry = { telemetryLevel = 'off' },
          advanced = { inlineSuggestCount = 3 },
        },
      },
      copilot_model = 'gpt-41-copilot',
      suggestion = {
        enabled = false,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = '<C-y><C-y>',
          accept_word = '<C-y><C-w>',
          accept_line = '<C-y><C-l>',
          next = '<M-]>',
          prev = '<M-[>',
          dismiss = '<C-]>',
        },
      },
      filetypes = {
        ['*'] = false,
        lua = true,
        go = true,
        zig = true,
        typescript = true,
        javascript = true,
        vue = true,
        c = true,
        cpp = true,
        proto = true,
        markdown = true,
        yaml = true,
      },
    },
  },
}
