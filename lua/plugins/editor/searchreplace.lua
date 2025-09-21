return {
  -- search/replace in multiple files
  {
    'nvim-pack/nvim-spectre',
    cmd = 'Spectre',
    keys = {
      {
        '<leader>sr',
        function()
          require('spectre').open()
        end,
        desc = 'Replace in files (Spectre)',
      },
      {
        '<leader>se',
        function()
          require('spectre').open_visual({ select_word = true })
        end,
        desc = 'Search current word',
      },
      {
        '<leader>sd',
        function()
          require('spectre').open_visual()
        end,
        desc = 'Search current word',
      },
      {
        '<leader>sf',
        function()
          require('spectre').open_file_search({ select_word = true })
        end,
        desc = 'Search on current file',
      },
    },
  },
}
