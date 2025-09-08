return {
  {
    'hedyhli/outline.nvim',
    lazy = true,
    cmd = { 'Outline', 'OutlineOpen' },
    keys = {
      { '<leader>so', '<cmd>Outline<cr>', desc = 'Toggle Symbol Outline' },
    },
    opts = {},
  },

  {
    'bassamsdata/namu.nvim',
    cmd = { 'Namu' },
    opts = {
      global = {},
      namu_symbols = {
        enable = true,
        options = {}, -- here you can configure namu
      },
      ui_select = { enable = false }, -- vim.ui.select() wrapper
    },
    keys = {
      { '<leader>ss', ':Namu symbols<cr>', mode = { 'n' }, desc = 'Jump to LSP symbol' },
      { '<leader>sw', ':Namu workspace<cr>', mode = { 'n' }, desc = 'LSP Symbols - Workspace' },
    },
  },
}
