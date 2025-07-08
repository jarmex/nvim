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
          default = 20000,
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
          default = 'gemini-2.5-pro-preview-05-06',
        },
      },
    }
    return require('codecompanion.adapters').extend('gemini', gemini_config)
  end,

  --- Gemini config for CodeCompanion.
  openrouter = function()
    local openrouter_config = {
      name = 'openrouter',
      formatted_name = 'OpenRouter',
      -- url = 'https://openrouter.ai/api/v1/chat/completions',
      env = {
        url = 'https://openrouter.ai/api',
        -- api_key = 'OPENROUTER_API_KEY',
        chat_url = '/v1/chat/completions',
        api_key = os.getenv('OPENROUTER_API_KEY'),
      },
      schema = {
        temperature = { default = 0.3 },
        maxOutputTokens = { default = 8192 },
        model = {
          default = 'openrouter/cypher-alpha:free',
          choices = {
            'openrouter/cypher-alpha:free',
            'mistralai/devstral-small:free',
            'qwen/qwen-2.5-coder-32b-instruct:free',
            'qwen/qwen3-235b-a22b:free',
            'qwen/qwen3-30b-a3b:free',
          },
        },
        -- num_ctx = { default = 200000 },
      },
    }
    return require('codecompanion.adapters').extend('openai_compatible', openrouter_config)
  end,
}
