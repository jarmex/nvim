return {
  'pwntester/octo.nvim',
  cmd = 'Octo',
  -- event = { { event = 'BufReadCmd', pattern = 'octo://*' } },
  dependencies = {
    'folke/snacks.nvim',
    'nvim-lua/plenary.nvim',
  },
  init = function()
    vim.treesitter.language.register('markdown', 'octo')
  end,
  opts = {
    enable_builtin = true,
    default_to_projects_v2 = true,
    suppress_missing_scope = {
      projects_v2 = true,
    },
    default_merge_method = 'squash',
    picker = 'snacks',
    use_local_fs = true,
  },
}
