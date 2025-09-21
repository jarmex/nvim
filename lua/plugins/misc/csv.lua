local csv_ft = { 'csv', 'tsv' }
return {
  -- {
  --   'theKnightsOfRohan/csvlens.nvim',
  --   ft = csv_ft,
  --   dependencies = {
  --     'akinsho/toggleterm.nvim',
  --   },
  --   cmd = { 'Csvlens' },
  --   keys = {
  --     { '<leader>cv', '<cmd>Csvlens "|"<cr>', desc = "CSV Lens with '|' separator", mode = { 'n', 'v' } },
  --   },
  --   config = true,
  -- },
  {
    'hat0uma/csvview.nvim',
    ft = csv_ft,
    keys = {
      { '<leader>cv', '<cmd>CsvViewToggle<cr>', desc = 'Csv View', ft = csv_ft },
    },
    cmd = {
      'CsvViewEnable',
      'CsvViewDisable',
      'CsvViewToggle',
    },
    ---@module "csvview"
    ---@type CsvView.Options
    opts = {
      parser = { comments = { '#', '//' } },
      keymaps = {
        textobject_field_inner = { 'if', mode = { 'o', 'x' } },
        textobject_field_outer = { 'af', mode = { 'o', 'x' } },
        jump_next_field_end = { '<tab>', mode = { 'n', 'v' } },
        jump_prev_field_end = { '<s-tab>', mode = { 'n', 'v' } },
        jump_next_row = { '<cr>', mode = { 'n', 'v' } },
        jump_prev_row = { '<s-cr>', mode = { 'n', 'v' } },
      },
    },
    config = function(_, opts)
      require('csvview').setup(opts)

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('csvview_auto_enable', { clear = true }),
        pattern = csv_ft,
        callback = function(event)
          local csvview = require('csvview')
          if not csvview.is_enabled(event.buf) then
            csvview.enable(event.buf)
          end
        end,
      })

      vim.api.nvim_create_autocmd('Filetype', {
        pattern = csv_ft,
        group = vim.api.nvim_create_augroup('CsvView', { clear = true }),
        callback = function()
          Snacks.toggle({
            name = 'csv view',
            get = function()
              return require('csvview').is_enabled(0)
            end,
            set = function(state)
              if state then
                require('csvview').enable()
              else
                require('csvview').disable()
              end
            end,
          }):map('<localleader>cc')
        end,
      })
    end,
  },
}
