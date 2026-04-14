-- If available, open the last chat, otherwise open a new chat
local function open_chat()
  local chat = require('codecompanion.interactions.chat').last_chat()
  if chat then
    chat.ui:open()
    vim.api.nvim_set_current_win(chat.ui.winnr)
  else
    vim.cmd('CodeCompanionChat')
  end
end

-- Smart Inline
--
-- Handle <leader>c mapping intelligently based on selection state.
-- No selection: Start with current file context
-- With selection: Use range-based CodeCompanion
local function smart_inline()
  local mode = vim.api.nvim_get_mode().mode
  local has_snacks = pcall(require, 'snacks.input')

  if has_snacks then
    -- Use snacks input
    if mode == 'n' then
      vim.ui.input({ prompt = 'CodeCompanion: ' }, function(input)
        if input and input ~= '' then
          vim.cmd('CodeCompanion #{buffer} ' .. input)
        end
      end)
    else
      vim.ui.input({ prompt = 'CodeCompanion: ' }, function(input)
        if input and input ~= '' then
          vim.cmd("'<,'>CodeCompanion " .. input)
        end
      end)
    end
  else
    -- Fallback to command line
    local prefix = mode == 'n' and ':CodeCompanion #{buffer} ' or ':CodeCompanion '
    vim.fn.feedkeys(prefix, 'n')
  end
end

local function ask_selection()
  vim.ui.input({ prompt = 'CodeCompanion Input: ' }, function(input)
    if not input then
      return
    end

    CodeCompanion = require('codecompanion')
    local prompt = input and '<prompt>\n' .. input .. '\n</prompt>' or ''
    local filetype = vim.api.nvim_get_option_value('filetype', { buf = 0 })
    local buffer_reference = '#{buffer}'
    local lines = vim.fn.getline(vim.fn.getpos("'<")[2], vim.fn.getpos("'>")[2])
    local text = ''
    if #lines ~= 0 then
      text = '```' .. filetype .. '\n' .. table.concat(lines, '\n') .. '\n```'
    end

    local content = '@{insert_edit_into_file}\n'
      .. buffer_reference
      .. '\n'
      .. text
      .. '\n'
      .. prompt
      .. '\nApply the changes directly to the file if requested.'

    local chat = CodeCompanion.last_chat()
    if not chat then
      chat = CodeCompanion.chat()
    end

    chat:add_buf_message({
      role = 'user',
      content = content,
    })
    chat:submit()
    -- chat.ui:hide()
  end)
end

return {
  {
    'ga',
    '<cmd>CodeCompanionChat Add<cr>',
    mode = { 'v' },
    desc = 'Add selection to CodeCompanionChat',
    silent = true,
  },
  {
    '<leader>at',
    '<cmd>CodeCompanionChat Toggle<CR>',
    desc = 'CodeCompanion Toggle',
    mode = { 'n', 'v' },
    silent = true,
  },
  { '<leader>aa', '<cmd>CodeCompanionActions<CR>', desc = '[A]I [A]ctions', mode = { 'n', 'v' }, silent = true },
  { '<leader>ad', ':CodeCompanionChat adapter=deepseek<CR>', desc = 'Codecompanion DeepSeek', silent = true },
  { '<leader>an', ':CodeCompanionChat adapter=anthropic<CR>', desc = 'Codecompanion Anthropic', silent = true },
  { '<leader>ao', ':CodeCompanionChat adapter=openai<CR>', desc = 'Codecompanion OpenAI', silent = true },
  { '<leader>au', ':CodeCompanionChat adapter=openrouter<CR>', desc = 'Codecompanion OpenRouter', silent = true },
  { '<leader>aq', ':CodeCompanionChat adapter=qwen<CR>', desc = 'Codecompanion Qwen', silent = true },
  { '<Leader>ah', '<Cmd>CodeCompanionHistory<CR>', desc = 'AI: Show chat history', silent = true },
  { '<leader>ai', ask_selection, mode = { 'n', 'v' }, desc = 'Code Companion Inline Prompt', silent = true },
  {
    '<leader>as',
    smart_inline,
    mode = { 'n', 'v' },
    desc = 'CodeCompanion Smart Inline',
    silent = true,
    noremap = true,
  },
  { '<Leader>ae', open_chat, desc = '[A]I CodeCompanion [c]hat', silent = true },
  { '<leader>al', ':CodeCompanionCLI<CR>', desc = 'Open Claude Code', silent = true },
  { '<leader>aC', ':CodeCompanionCLI agent=codex<CR>', desc = 'Open Codex', silent = true },
  {
    '<leader>as',
    '<cmd>CodeCompanionChat /write-tests<CR>',
    mode = 'v',
    desc = 'Generate Tests (CodeCompanion)',
    silent = true,
  },
  {
    '<Leader>ap',
    function()
      return require('codecompanion').cli({ prompt = true })
    end,
    mode = { 'n', 'v' },
    desc = 'Prompt the CLI agent',
    silent = true,
  },
  -- [C]odeCompanion [D]iagnostics
  vim.keymap.set('n', '<LocalLeader>cd', function()
    return require('codecompanion').cli('#{diagnostics} Can you fix these?', { focus = false, submit = true })
  end, { desc = 'Send diagnostics to CLI agent' }),
  -- [C]odeCompanion [A]dd
  vim.keymap.set({ 'n', 'v' }, '<LocalLeader>aT', function()
    return require('codecompanion').cli('#{this}', { focus = false })
  end, { desc = 'Add context to the CLI agent' }),
}
