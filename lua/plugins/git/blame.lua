return {
  {
    'FabijanZulj/blame.nvim',
    -- lazy = false,
    cmd = 'BlameToggle',
    config = function()
      require('blame').setup({})
    end,
  },
}
