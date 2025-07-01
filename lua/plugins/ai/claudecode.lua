return {
  'coder/claudecode.nvim',
  dependencies = { 'folke/snacks.nvim' },
  enabled = not (vim.fn.has('win32') == 1),
  keys = {
    { '<leader>a', nil, desc = 'AI/Claude Code' },
    { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
    { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
    { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
    { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
    { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
    { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
    {
      '<leader>as',
      '<cmd>ClaudeCodeTreeAdd<cr>',
      desc = 'Add file',
      ft = { 'NvimTree', 'neo-tree', 'oil' },
    },
    -- Diff management
    { '<leader>av', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
    { '<leader>ax', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
  },
  opts = {
    terminal = {
      split_side = 'right', -- "left" or "right"
      split_width_percentage = 0.40,
      provider = 'snacks', -- "auto", "snacks", or "native"
      auto_close = true,
    },
  },
}
