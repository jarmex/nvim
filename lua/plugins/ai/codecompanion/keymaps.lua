-- If available, open the last chat, otherwise open a new chat
local function open_chat()
  local chat = require('codecompanion.strategies.chat').last_chat()
  if chat then
    chat.ui:open()
    vim.api.nvim_set_current_win(chat.ui.winnr)
  else
    vim.cmd('CodeCompanionChat')
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
  { 'ga', '<cmd>CodeCompanionChat Add<cr>', mode = { 'v' }, desc = 'Add Visual' },
  { '<leader>ai', '<cmd>CodeCompanion<cr>', mode = { 'n', 'v' }, desc = 'InlineCode' },
  { '<leader>at', '<cmd>CodeCompanionChat Toggle<CR>', desc = 'CodeCompanion Toggle', mode = { 'n', 'v' } },
  { '<leader>aa', '<cmd>CodeCompanionActions<CR>', desc = '[A]I [A]ctions', mode = { 'n', 'v' } },
  { '<leader>ad', ':CodeCompanionChat deepseek<CR>', desc = 'Codecompanion DeepSeek' },
  { '<leader>ag', ':CodeCompanionChat gemini<CR>', desc = 'Codecompanion: Gemini' },
  { '<leader>al', ':CodeCompanionChat ollama<CR>', desc = 'Codecompanion Ollama' },
  { '<leader>an', ':CodeCompanionChat anthropic<CR>', desc = 'Codecompanion Anthropic' },
  { '<leader>ao', ':CodeCompanionChat openai<CR>', desc = 'Codecompanion OpenAI' },
  { '<leader>au', ':CodeCompanionChat openrouter<CR>', desc = 'Codecompanion OpenRouter' },
  { '<leader>aq', ':CodeCompanionChat qwen<CR>', desc = 'Codecompanion Qwen' },
  { '<Leader>aA', '<Cmd>lua require("codecompanion.strategies.inline"):stop()<CR>', desc = 'AI: Abort inline request' },
  { '<Leader>ah', '<Cmd>CodeCompanionHistory<CR>', desc = 'AI: Show chat history' },
  { '<leader>aj', ask_selection, mode = { 'n', 'v' }, desc = 'Code Companion Inline Prompt' },
  { '<Leader>Ac', open_chat, desc = '[A]I CodeCompanion [c]hat' },
  { '<leader>af', '<cmd>CodeCompanion /fix<cr>', mode = 'v', desc = 'Fix Code (CodeCompanion)' },
  {
    '<leader>ay',
    '<cmd>CodeCompanion /tests<cr>',
    mode = 'v',
    desc = 'Generate Tests (CodeCompanion)',
  },
}
