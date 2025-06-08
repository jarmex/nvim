return {
  { 'ga', '<cmd>CodeCompanionChat Add<cr>', mode = { 'v' }, desc = 'Add Visual' },
  { '<leader>ai', '<cmd>CodeCompanion<cr>', mode = { 'n', 'v' }, desc = 'InlineCode' },
  { '<leader>at', '<cmd>CodeCompanionChat Toggle<CR>', desc = 'AI Toggle', mode = { 'n', 'v' } },
  { '<leader>aa', '<cmd>CodeCompanionActions<CR>', desc = '[A]I [A]ctions', mode = { 'n', 'v' } },
  { '<leader>ad', ':CodeCompanionChat deepseek<CR>', desc = 'Codecompanion Anthropic' },
  { '<leader>an', ':CodeCompanionChat anthropic<CR>', desc = 'Codecompanion Anthropic' },
  { '<leader>ag', ':CodeCompanionChat gemini<CR>', desc = 'Codecompanion: Gemini' },
  { '<leader>al', ':CodeCompanionChat ollama<CR>', desc = 'Codecompanion Ollama' },
  { '<leader>ao', ':CodeCompanionChat openai<CR>', desc = 'Codecompanion OpenAI' },
  { '<leader>ar', ':CodeCompanionChat openrouter<CR>', desc = 'Codecompanion OpenRouter' },
  {
    '<leader>ah',
    function()
      vim.cmd('CodeCompanionHistory')
    end,
    mode = 'n',
    desc = 'AI: Show chat history',
  },
}
