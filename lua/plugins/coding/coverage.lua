return {
  --  Shows a float panel with the [code coverage]
  --  https://github.com/andythigpen/nvim-coverage
  --
  --  Your project must generate coverage/lcov.info for this to work.
  --
  --  On jest, make sure your packages.json file has this:
  --  "tests": "jest --coverage"
  --
  --  If you use other framework or language, refer to nvim-coverage docs:
  --  https://github.com/andythigpen/nvim-coverage/blob/main/doc/nvim-coverage.txt
  {
    'andythigpen/nvim-coverage',
    event = 'VeryLazy',
    cmd = {
      'Coverage',
      'CoverageLoad',
      'CoverageLoadLcov',
      'CoverageShow',
      'CoverageHide',
      'CoverageToggle',
      'CoverageClear',
      'CoverageSummary',
    },
    opts = {
      auto_reload = true,
      lang = {
        go = {
          coverage_file = vim.fn.getcwd() .. '/coverage.out',
        },
        python = {
          coverage_file = vim.fn.getcwd() .. '/coverage.out',
        },
      },
    },

    keys = {
      {
        '<leader>lcc',
        function()
          require('coverage').load(true)
        end,
        desc = 'Show coverage',
      },
      {
        '<leader>lcl',
        function()
          require('coverage').load(false)
        end,
        desc = 'Load coverage',
      },
      {
        '<leader>lch',
        function()
          require('coverage').hide()
        end,
        desc = 'Hide coverage',
      },
      {
        '<leader>lct',
        function()
          require('coverage').load(false)
          require('coverage').toggle()
        end,
        desc = 'Toggle coverage',
      },
      {
        '<leader>lcs',
        function()
          require('coverage').load(false)
          require('coverage').summary()
        end,
        desc = 'Show coverage summary',
      },
    },
  },
}
