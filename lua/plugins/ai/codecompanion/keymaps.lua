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
}
