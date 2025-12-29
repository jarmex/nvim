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
    {
      '<leader>cb',
      ':Convy auto b64<CR>',
      desc = 'Convert to base64',
      mode = { 'n', 'v' },
      silent = true,
    },
  },
}
