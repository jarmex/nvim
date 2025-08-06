return {
  'kndndrj/nvim-dbee',
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
  cmd = { 'DB' },
  build = function()
    -- Install tries to automatically detect the install method.
    -- if it fails, try calling it with one of these parameters:
    --    "curl", "wget", "bitsadmin", "go"
    require('dbee').install()
  end,
  config = function()
    require('dbee').setup({
      drawer = {
        mappings = {
          { key = '<tab>', mode = 'n', action = 'toggle' },
          -- these are all the defaults but you have to override everything if any of the mappings are different
          { key = 'r', mode = 'n', action = 'refresh' },
          { key = '<CR>', mode = 'n', action = 'action_1' },
          { key = 'cw', mode = 'n', action = 'action_2' },
          { key = 'dd', mode = 'n', action = 'action_3' },
          { key = 'o', mode = 'n', action = 'toggle' },
          { key = '<CR>', mode = 'n', action = 'menu_confirm' },
          { key = 'y', mode = 'n', action = 'menu_yank' },
          { key = '<Esc>', mode = 'n', action = 'menu_close' },
          { key = 'q', mode = 'n', action = 'menu_close' },
        },
        window_options = { foldcolumn = '0' },
      },
    })

    vim.api.nvim_create_user_command('DB', function()
      local dbee = require('dbee')
      if dbee.is_open() then
        dbee.close()
      else
        vim.cmd('tab split')
        dbee.open()
      end
    end, { desc = 'Toggle dbee UI' })
  end,
}
