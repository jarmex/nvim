-- adapted from https://github.com/qw457812/dotfiles/blob/main/dot_config/nvim/lua/plugins/extras/ai/claude-code.lua

if vim.fn.executable('claude') == 0 then
  print('No claude installation')
  return {}
end
local H = {}

H.toggle_key = '<C-,>'

---@param buf? integer
---@return boolean
function H.is_cc(buf)
  buf = buf or 0
  return vim.bo[buf].filetype == 'snacks_terminal' and vim.api.nvim_buf_get_name(buf):match('^term://.*:claude')
end

---Whether the claude code is in his own normal mode.
---@param buf? integer
---@return boolean?
function H.is_cc_norm(buf)
  buf = buf or 0
  if not H.is_cc(buf) then
    return false
  end

  local has_input_prompt = false
  local lines = vim.api.nvim_buf_get_lines(buf, -50, -1, false)
  for i, line in ipairs(lines) do
    -- selecting, not inputting
    -- - `│ ❯ Editor mode                               vim                                 │` of `/config`
    -- - `│ ❯ 1. Yes                                                                        │` of `Do you want to make this edit to <file>?`
    if line:match('^│ ❯ .+') then
      return false
    end

    if line:match('^  %-%- INSERT %-%- ') or line:match('^  %-%- INSERT MODE %-%- ') then
      return false
    end
    if line:match('^  %? for shortcuts ') or line:match('^  %-%- NORMAL MODE %-%- ') then
      return true
    end

    -- ╭──────────────────────────────────────────────────────────╮
    -- │ >                                                        │
    -- ╰──────────────────────────────────────────────────────────╯
    --                                       ⧉ In claude-code.lua
    --
    -- ╭──────────────────────────────────────────────────────────╮
    -- │ > 11111111111111111111111111111111111111111111111111111  │
    -- │   111                                                    │
    -- ╰──────────────────────────────────────────────────────────╯
    --                                         ◯ IDE disconnected
    --
    -- ╭──────────────────────────────────────────────────────────╮
    -- │ > 1                                                      │
    -- ╰──────────────────────────────────────────────────────────╯
    --                                                          ◯
    if line:match('^╭─.+─╮$') and lines[i + 1]:match('^│ > .*  │$') then
      has_input_prompt = true
    elseif
      has_input_prompt
      and line:match('^╰─.+─╯$')
      and (
        lines[i + 1]:match('^%s+◯ IDE disconnected$')
        or lines[i + 1]:match('^%s+◯$')
        or lines[i + 1]:match('^%s+⧉ In .+')
      )
    then
      -- empty mode means normal mode
      return true
    end
  end
end

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
    init = function()
      -- see: https://github.com/coder/claudecode.nvim/issues/52#issuecomment-2993522840
      vim.env.CLAUDE_CONFIG_DIR = vim.fn.expand('~/.config/claude')
    end,
    opts = function()
      vim.api.nvim_create_autocmd('TermOpen', {
        pattern = 'term://*:claude*',
        callback = function(ev)
          if vim.bo[ev.buf].filetype == 'snacks_terminal' then
            vim.b[ev.buf].user_lualine_filename = 'claude_code'
          end
        end,
      })

      vim.api.nvim_create_autocmd('TermEnter', {
        group = vim.api.nvim_create_augroup('claude_vi_mode', {}),
        pattern = 'term://*:claude*',
        desc = 'Enter insert mode of claude code',
        callback = vim.schedule_wrap(function()
          if H.is_cc_norm() then
            vim.api.nvim_feedkeys(vim.keycode('i'), 'n', false)
          end
        end),
      })

      return {
        terminal = {
          split_side = 'right', -- "left" or "right"
          split_width_percentage = 0.40,
          provider = 'snacks', -- "auto", "snacks", or "native"
          auto_close = true,
        },
      }
    end,
  },
}
