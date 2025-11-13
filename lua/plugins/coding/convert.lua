return {
  'necrom4/convy.nvim',
  cmd = 'Convy',
  opts = {
    notifications = true,
  },
  keys = {
    {
      '<leader>cc',
      ':Convy<cr>',
      desc = 'Convert (interactive selection)',
      mode = { 'n', 'v' },
      silent = true,
    },
  },
}
