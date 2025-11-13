return {
  'topaxi/pipeline.nvim',
  keys = {
    { '<leader>ci', '<cmd>Pipeline<cr>', desc = 'Open pipeline' },
  },
  opts = {
    refresh_interval = 10,

    dispatch_branch = 'default',

    split = {
      relative = 'editor',
      position = 'right',
      size = 60,
    },
  },
}
