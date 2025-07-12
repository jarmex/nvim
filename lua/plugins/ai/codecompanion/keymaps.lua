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
  { '<Leader>aA', '<Cmd>lua require("codecompanion.strategies.inline"):stop()<CR>', desc = 'AI: Abort inline request' },
  { '<Leader>ah', '<Cmd>CodeCompanionHistory<CR>', desc = 'AI: Show chat history' },
  { '<Leader>Ac', open_chat, desc = '[A]I CodeCompanion [c]hat' },
}
