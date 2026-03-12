return {
  'necrom4/convy.nvim',
  cmd = 'Convy',
  opts = {
    notifications = true,
  },
  keys = {
    {
      '<leader>vy',
      ':Convy<cr>',
      desc = 'Convert (interactive selection)',
      mode = { 'n', 'v' },
      silent = true,
    },
    {
      '<leader>vb',
      ':Convy ascii b64<CR>',
      desc = 'Convert to base64',
      mode = { 'v' },
      silent = true,
    },
    {
      '<leader>va',
      ':Convy b64 ascii<CR>',
      desc = 'Convert from base64',
      mode = { 'v' },
      silent = true,
    },
  },
}
