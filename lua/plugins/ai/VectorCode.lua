return {
  'Davidyz/VectorCode', -- Index and search code in your repositories
  enabled = false,
  -- version = '*',
  event = 'VeryLazy',
  cmd = 'VectorCode',
  build = 'uv tool install --upgrade vectorcode',
  opts = function()
    return {
      async_backend = 'lsp',
      notify = true,
      on_setup = { lsp = false },
      n_query = 10,
      timeout_ms = -1,
      async_opts = {
        events = { 'BufWritePost' },
        single_job = true,
        query_cb = require('vectorcode.utils').make_surrounding_lines_cb(40),
        debounce = -1,
        n_query = 30,
      },
    }
  end,
  keys = {
    {
      '<leader>av',
      function()
        return require('vectorcode').update()
      end,
      desc = 'Update (VectorCode)',
      mode = { 'n', 'v' },
    },
  },
  config = function(_, opts)
    require('vectorcode').setup(opts)
  end,
}
