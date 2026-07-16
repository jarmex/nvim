---@module "codecompanion"
---@type CodeCompanion.Config
return {
  http = {
    opts = {
      show_presets = true,
    },
    extend = {
      anthropic = { env = {} },
      deepseek = { env = { api_key = os.getenv('DEEPSEEK_API_KEY') } },
      gemini = {},
      mistral = {},
      openai = {},
      openai_responses = {},
      openrouter = { env = { api_key = os.getenv('OPENROUTER_API_KEY') } },
    },
    openrouter_title_generation = function()
      return require('codecompanion.adapters').extend('openrouter', {
        env = { api_key = 'OPENROUTER_API_KEY' },
        opts = { session_id = 'title_generation' },
        schema = {
          model = {
            default = 'deepseek/deepseek-v4-flash',
          },
        },
      })
    end,
  },
  acp = require('plugins.ai.codecompanion.adapters.acp'),
}
