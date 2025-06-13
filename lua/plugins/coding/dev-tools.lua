return {
  'yarospace/dev-tools.nvim',
  enabled = false,
  dependencies = {
    'nvim-treesitter/nvim-treesitter', -- code manipulation in buffer, required
    {
      'folke/snacks.nvim', -- optional
      opts = {
        picker = { enabled = true }, -- actions picker
        terminal = { enabled = true }, -- terminal for running spec actions
      },
    },
    {
      'ThePrimeagen/refactoring.nvim', -- refactoring library, optional
      dependencies = { 'nvim-lua/plenary.nvim' },
    },
  },

  opts = {
    ---@type Action[]|fun():Action[]
    actions = {},

    filetypes = { -- filetypes for which to attach the LSP
      include = {}, -- {} to include all, except for special buftypes, e.g. nofile|help|terminal|prompt
      exclude = {},
    },
  },
}
