---@module "codecompanion"
---@type CodeCompanion.Config
return {
  --- Anthropic config for CodeCompanion.
  anthropic = function()
    local anthropic_config = {
      schema = {
        model = {
          default = 'claude-sonnet-4-20250514',
        },
        max_tokens = {
          default = 8192,
          -- default = 28000,
        },
        extended_output = {
          default = false,
        },
        extended_thinking = {
          default = false,
        },
      },
    }
    return require('codecompanion.adapters').extend('anthropic', anthropic_config)
  end,

  --- OpenAI config for CodeCompanion.
  openai = function()
    local openai_config = {
      opts = {
        stream = true,
      },
      schema = {
        model = {
          default = 'gpt-4.1',
        },
      },
    }
    return require('codecompanion.adapters').extend('openai', openai_config)
  end,

  deepseek = function()
    return require('codecompanion.adapters').extend('deepseek', {
      env = {
        api_key = os.getenv('DEEPSEEK_API_KEY'),
      },
      schema = {
        model = {
          default = 'deepseek-chat',
          -- default = 'deepseek-reasoner',
        },
        temperature = {
          default = 0.3,
        },
      },
    })
  end,

  --- Ollama config for CodeCompanion.
  ollama = function()
    return require('codecompanion.adapters').extend('ollama', {
      name = 'ollama',
      schema = {
        model = {
          default = 'qwen2.5-coder:3b',
        },
        num_ctx = {
          default = 32768,
        },
        temperature = {
          default = 0.3,
        },
        num_predict = {
          default = -1,
        },
      },
    })
  end,

  --- Gemini config for CodeCompanion.
  gemini = function()
    local gemini_config = {
      schema = {
        temperature = { default = 0.3 },
        num_ctx = { default = 200000 },
        model = {
          default = 'gemini-2.5-flash',
        },
      },
    }
    return require('codecompanion.adapters').extend('gemini', gemini_config)
  end,

  openrouter = function()
    local openrouter_config = {
      name = 'openrouter',
      formatted_name = 'OpenRouter',
      env = {
        url = 'https://openrouter.ai/api',
        chat_url = '/v1/chat/completions',
        api_key = os.getenv('OPENROUTER_API_KEY'),
      },
      schema = {
        temperature = { default = 0.3 },
        maxOutputTokens = { default = 8192 },
        model = {
          default = 'qwen/qwen3-coder:free',
          choices = {
            'z-ai/glm-4.5',
            'z-ai/glm-4.5-air:free',
            'qwen/qwen3-coder',
            'qwen/qwen3-coder:free',
            'qwen/qwen3-235b-a22b-07-25:free',
            'mistralai/devstral-small:free',
            'moonshotai/kimi-k2:free',
            'moonshotai/kimi-k2',
            'qwen/qwen3-235b-a22b-07-25',
          },
        },
      },
    }
    return require('codecompanion.adapters').extend('openai_compatible', openrouter_config)
  end,
}
