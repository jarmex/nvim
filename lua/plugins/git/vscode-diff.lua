return {
  {
    'esmuellert/codediff.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    cmd = 'CodeDiff',
    opts = {
      highlights = {
        line_insert = 'DiffAdd',
        line_delete = 'DiffDelete',

        char_insert = nil,
        char_delete = nil,
      },
      -- Diff view behavior
      diff = {
        disable_inlay_hints = true,
        max_computation_time_ms = 5000,
      },

      -- Explorer panel configuration
      explorer = {
        view_mode = 'tree',
        file_filter = {
          ignore = { '*.pb.go' },
        },
      },
      -- Keymaps in diff view
      keymaps = {
        view = {
          next_hunk = ']c',
          prev_hunk = '[c',
          next_file = ']f',
          prev_file = '[f',
        },
        explorer = {
          select = '<CR>',
          hover = 'K',
          refresh = 'R',
        },
      },
    },
    keys = {
      { '<leader>gdc', '<cmd>CodeDiff<cr>', desc = 'Diff file explorer' },
      { '<leader>gdj', '<cmd>CodeDiff file HEAD<cr>', desc = 'Diff with HEAD' },
      { '<leader>gdk', '<cmd>CodeDiff file HEAD~1<cr>', desc = 'Diff with HEAD~1' },
      { '<leader>gdl', '<cmd>CodeDiff<cr>', desc = 'Diff file explorer' },
      { '<leader>da', ':CodeDiff file ', desc = 'Diff with commit...', silent = false },
      { '<leader>dm', ':CodeDiff file ', desc = 'Diff two files...', silent = false },
    },
  },
}
