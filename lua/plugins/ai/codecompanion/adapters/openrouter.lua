local adapters = require('codecompanion.adapters')

return function()
  local openrouter_config = {
    name = 'openrouter',
    formatted_name = 'OpenRouter',
    env = {
      url = 'https://openrouter.ai/api/v1',
      chat_url = '/chat/completions',
      api_key = os.getenv('OPENROUTER_API_KEY'),
      models_endpoint = '/models',
    },
    schema = {
      model = {
        default = 'minimax/minimax-m2',
        choices = {
          'z-ai/glm-4.6',
          'minimax/minimax-m2',
          'x-ai/grok-code-fast-1',
          'deepseek/deepseek-v3.2-exp',
          'qwen/qwen3-coder',
          'deepseek/deepseek-v3.2-exp',
          'moonshotai/kimi-k2-0905',
          'deepseek/deepseek-v3.1-terminus',
          'moonshotai/kimi-k2-thinking',
        },
      },
    },
  }
  return adapters.extend('openai_compatible', openrouter_config)
end
