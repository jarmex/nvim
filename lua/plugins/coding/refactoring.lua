return {
  {
    'ThePrimeagen/refactoring.nvim', -- Refactor code like Martin Fowler
    enabled = true,
    event = { 'BufReadPre', 'BufNewFile' },
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
        '<leader>rb',
        function()
          return require('refactoring').refactor('Extract Block')
        end,
        desc = 'Extract Block',
        noremap = true,
        expr = true,
        mode = { 'n' },
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
        '<leader>rP',
        function()
          return require('refactoring').debug.printf({ below = false })
        end,
        desc = 'Debug Print',
      },
      {
        '<leader>rp',
        function()
          return require('refactoring').debug.print_var({ normal = true })
        end,
        desc = 'Debug Print Variable',
      },
      {
        '<leader>rc',
        function()
          return require('refactoring').debug.cleanup({})
        end,
        mode = { 'n' },
        expr = true,
        desc = 'Clear debug print statement.',
      },
      {
        '<leader>ro',
        function()
          return require('refactoring').refactor('Extract Block To File')
        end,
        desc = 'Extract block to file',
        noremap = true,
        expr = true,
        mode = { 'n' },
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
        '<leader>rF',
        function()
          return require('refactoring').refactor('Extract Function To File')
        end,
        mode = 'v',
        desc = 'Extract Function To File',
      },
      {
        '<leader>rx',
        function()
          return require('refactoring').refactor('Extract Variable')
        end,
        mode = 'v',
        desc = 'Extract Variable',
      },
      {
        '<leader>rp',
        function()
          ---@diagnostic disable-next-line: missing-parameter
          return require('refactoring').debug.print_var()
        end,
        mode = { 'n' },
        expr = true,
        desc = 'Add debug print statement.',
      },
    },
    opts = {
      prompt_func_return_type = {
        go = true,
        java = false,
        cpp = false,
        c = false,
        h = false,
        hpp = false,
        cxx = false,
      },
      prompt_func_param_type = {
        go = false,
        java = false,
        cpp = false,
        c = false,
        h = false,
        hpp = false,
        cxx = false,
      },
      printf_statements = {},
      print_var_statements = {},
      show_success_message = true, -- shows a message with information about the refactor on success
      extract_var_statements = {
        go = '%s := %s',
      },
    },
  },
}
