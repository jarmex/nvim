---@module "lazy"
---@type LazySpec
return {
  {
    'coder/claudecode.nvim',
    dependencies = { 'folke/snacks.nvim' },
    cmd = 'ClaudeCode',
    keys = {
      { '<leader>a', nil, desc = 'AI/Claude Code' },
      { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
      { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
      { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
      { '<leader>a.', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
      { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
      {
        '<leader>a=',
        '<cmd>ClaudeCodeTreeAdd<cr>',
        desc = 'Add file (Claude)',
        ft = { 'NvimTree', 'neo-tree', 'oil' },
      },
      {
        '<leader>ab',
        function()
          vim.cmd('ClaudeCodeAdd %')
          vim.schedule(function()
            vim.cmd('ClaudeCodeFocus')
          end)
        end,
        desc = 'Add Buffer (Claude)',
      },
      -- Diff management
      { '<leader>av', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
      { '<leader>ax', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
    },
    opts = function()
      return {
        terminal_cmd = '~/.claude/local/claude',
        terminal = {
          split_side = 'right', -- "left" or "right"
          split_width_percentage = 0.45,
          provider = 'snacks', -- "auto", "snacks", or "native"
          auto_close = true,
        },
      }
    end,
  },
}
