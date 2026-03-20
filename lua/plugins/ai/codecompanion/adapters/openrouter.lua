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
    -- from https://github.com/Davidyz/dotfiles/blob/5635536d0151a59dd767da5505a91ecc7d6449ff/neovim/lua/plugin_specs/ai.lua
    handlers = {
      parse_extra = function(_, data)
        local extra = data.extra
        if extra and extra.reasoning then
          data.output.reasoning = { content = extra.reasoning }
          if data.output.content == '' then
            data.output.content = nil
          end
        end
        return data
      end,
    },
    schema = {
      model = {
        default = 'google/gemini-3.1-flash-lite-preview',
        -- default = 'moonshotai/kimi-k2.5',
        choices = {
          'z-ai/glm-5-turbo',
          'qwen/qwen3-coder-next',
          'minimax/minimax-m2.7',
          'xiaomi/mimo-v2-pro',
          ['google/gemini-3.1-flash-lite-preview'] = { opts = { can_reason = true } },
          ['moonshotai/kimi-k2.5'] = { opts = { can_reason = true } },
          ['deepseek/deepseek-r1:free'] = { opts = { can_reason = true } },
          ['deepseek/deepseek-v3.2'] = { opts = { can_reason = true } },
          ['deepseek/deepseek-v3.2-speciale'] = { opts = { can_reason = true } },
        },
      },
    },
  }
  return adapters.extend('openai_compatible', openrouter_config)
end
