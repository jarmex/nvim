return {
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    dependencies = {
      { 'Bilal2453/luvit-meta' },
      { 'folke/snacks.nvim' },
    },
    opts = {
      library = {
        -- Or relative, which means they will be resolved from the plugin dir.
        'lazy.nvim',
        'luvit-meta/library',
        'neotest',
        'plenary',
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
        { path = 'snacks.nvim', words = { 'Snacks' } },
        { path = 'lazy.nvim', words = { 'LazyVim' } },
      },
    },
  },
}
