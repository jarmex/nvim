return {
  'Davidyz/VectorCode', -- Index and search code in your repositories
  version = '*',
  build = 'uv tool install --upgrade vectorcode',
  dependencies = { 'nvim-lua/plenary.nvim' },
  event = 'VeryLazy',
  cmd = 'VectorCode',
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
  config = function(_, opts)
    -- vim.lsp.config("vectorcode_server", {
    --     cmd_env = {
    --       HTTP_PROXY = os.getenv("HTTP_PROXY"),
    --       HTTPS_PROXY = os.getenv("HTTPS_PROXY"),
    --     },
    --   })
    require('vectorcode').setup(opts)
  end,
}
