return {
  {
    'ThePrimeagen/refactoring.nvim', -- Refactor code like Martin Fowler
    enabled = true,
    branch = 'develop',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'lewis6991/async.nvim' },
    keys = {
      { '<leader>r', '', desc = '+refactor', mode = { 'n', 'v' } },
      {
        '<leader>ri',
        function()
          return require('refactoring').refactor('Inline Variable')
        end,
        mode = { 'n', 'v' },
        desc = 'Inline Variable',
        noremap = true,
        expr = true,
      },
      {
        '<Leader>re',
        function()
          return require('refactoring').select_refactor({ prefer_ex_cmd = false })
        end,
        desc = 'Open Refactoring',
        mode = { 'n', 'v', 'x' },
      },
      {
        '<leader>rf',
        function()
          return require('refactoring').refactor('Extract Function')
        end,
        desc = 'Extract Function',
        noremap = true,
        expr = true,
        mode = { 'x', 'v' },
      },
      {
        '<leader>rv',
        function()
          return require('refactoring').refactor('Extract Variable')
        end,
        mode = 'v',
        desc = 'Extract Variable',
      },
    },
  },
}
