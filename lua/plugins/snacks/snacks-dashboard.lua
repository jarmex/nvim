local logo_path = vim.fn.stdpath('config') .. '/'
return {
  'folke/snacks.nvim',
  opts = {
    dashboard = {
      enabled = true,
      width = 72,
      autokeys = 'abcdefghijklmnopqrstuvwxyz1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ',
      preset = {
        keys = {
          {
            icon = ' ',
            key = 'f',
            desc = 'Find File',
            action = ':lua Snacks.picker.smart({filter = {cwd = true}})',
          },
          -- { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
          { icon = ' ', key = 's', desc = 'Load Session', section = 'session' },
          -- { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
          -- {
          --   icon = ' ',
          --   key = 'c',
          --   desc = 'Config',
          --   action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          -- },
          { icon = '󱘣 ', key = '/', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
          -- { icon = ' ', key = 'm', desc = 'Show mark', action = ":lua Snacks.dashboard.pick('marks')" },
          -- { icon = ' ', key = 't', desc = 'Show todo', action = ':TodoQuickFix' },
          -- { icon = '󰒲 ', key = 'l', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
          {
            icon = '󱕻',
            key = 'o',
            desc = "Today's Daily Note",
            action = ':Obsidian today',
          },
          {
            icon = '󰭹 ',
            key = 'a',
            desc = 'AI Chat As',
            action = function()
              require('codecompanion').actions({})
              -- require('codecompanion').chat()
            end,
          },
          -- { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
        },
      },
      sections = {
        {
          section = 'terminal',
          align = 'center',
          -- cmd = 'lolcat --seed=24 ~/.config/nvim/static/neo2.cat; sleep .1',
          cmd = 'bash ' .. logo_path .. 'rainbow-logo.sh --speed 20 --play ' .. logo_path .. 'rainbow-logo.cache',
          -- cmd = 'bash ' .. logo_path .. 'rainbow-logo.sh --speed 20',
          height = 14,
          width = 69,
          padding = 1,
        },
        {
          align = 'center',
          padding = 1,
          text = {
            { '  Update ', hl = 'Label' },
            { '  Sessions ', hl = '@property' },
            { '  Last Session ', hl = 'Number' },
            { '  Files ', hl = 'DiagnosticInfo' },
            { '  Recent ', hl = '@string' },
          },
        },
        {
          section = 'keys',
          indent = 1,
          gap = 1,
          padding = 1,
        },
        { icon = '󰏓 ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
        { icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
        { text = '', hidden = true, action = ':Lazy update', key = 'u' },
        -- { text = '', hidden = true, action = ':PersistenceLoadSession', key = 's' },
        { icon = ' ', hidden = true, text = '', key = 'q', desc = 'Quit', action = ':qa' },
        {
          text = '',
          hidden = true,
          action = function()
            Snacks.picker.recent()
          end,
          key = 'r',
        },
        { section = 'startup' },
      },
    },
  },
}
