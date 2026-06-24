local adapters = require('codecompanion.adapters')

return function()
  local openrouter_config = {
    name = 'openrouter',
    formatted_name = 'OpenRouter',
    env = {
      api_key = os.getenv('OPENROUTER_API_KEY'),
    },
    schema = {
      model = {
        default = 'deepseek/deepseek-v4-flash',
        choices = {
          'google/gemini-3.1-flash-lite',
          'google/gemini-3.5-flash',
          'openrouter/fusion',
          'minimax/minimax-m3',
          'qwen/qwen3.7-max',
          'qwen/qwen3.6-flash',
          'xiaomi/mimo-v2.5-pro',
          'deepseek/deepseek-v4-flash',
          'z-ai/glm-5.2',
          'moonshotai/kimi-k2.7-code',
        },
      },
    },
  }
  return adapters.extend('openrouter', openrouter_config)
end
