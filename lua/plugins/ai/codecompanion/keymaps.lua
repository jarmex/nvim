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
  {
    'ga',
    '<cmd>CodeCompanionChat Add<cr>',
    mode = { 'v' },
    desc = 'Add selection to CodeCompanionChat',
    silent = true,
  },
  { '<leader>ai', '<cmd>CodeCompanion<cr>', mode = { 'n', 'v' }, desc = 'InlineCode', silent = true },
  {
    '<leader>at',
    '<cmd>CodeCompanionChat Toggle<CR>',
    desc = 'CodeCompanion Toggle',
    mode = { 'n', 'v' },
    silent = true,
  },
  { '<leader>aa', '<cmd>CodeCompanionActions<CR>', desc = '[A]I [A]ctions', mode = { 'n', 'v' }, silent = true },
  { '<leader>ad', ':CodeCompanionChat deepseek<CR>', desc = 'Codecompanion DeepSeek', silent = true },
  { '<leader>ag', ':CodeCompanionChat gemini<CR>', desc = 'Codecompanion: Gemini', silent = true },
  { '<leader>al', ':CodeCompanionChat ollama<CR>', desc = 'Codecompanion Ollama', silent = true },
  { '<leader>an', ':CodeCompanionChat anthropic<CR>', desc = 'Codecompanion Anthropic', silent = true },
  { '<leader>ao', ':CodeCompanionChat openai<CR>', desc = 'Codecompanion OpenAI', silent = true },
  { '<leader>au', ':CodeCompanionChat openrouter<CR>', desc = 'Codecompanion OpenRouter', silent = true },
  { '<leader>aq', ':CodeCompanionChat qwen<CR>', desc = 'Codecompanion Qwen', silent = true },
  {
    '<Leader>aA',
    '<Cmd>lua require("codecompanion.strategies.inline"):stop()<CR>',
    desc = 'AI: Abort inline request',
    silent = true,
  },
  { '<Leader>ah', '<Cmd>CodeCompanionHistory<CR>', desc = 'AI: Show chat history', silent = true },
  { '<leader>aj', ask_selection, mode = { 'n', 'v' }, desc = 'Code Companion Inline Prompt', silent = true },
  { '<Leader>Ac', open_chat, desc = '[A]I CodeCompanion [c]hat', silent = true },
  { '<leader>af', '<cmd>CodeCompanion /fix<cr>', mode = 'v', desc = 'Fix Code (CodeCompanion)' },
  silent = true,
  {
    '<leader>ay',
    '<cmd>CodeCompanion /tests<cr>',
    mode = 'v',
    desc = 'Generate Tests (CodeCompanion)',
    silent = true,
  },
}
