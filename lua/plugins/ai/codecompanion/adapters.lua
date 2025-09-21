---@module "codecompanion"
---@type CodeCompanion.Config
return {
  acp = {
    claude_code = function()
      return require('codecompanion.adapters').extend('claude_code', {
        env = {
          CLAUDE_CODE_OAUTH_TOKEN = os.getenv('CLAUDE_CODE_OAUTH_TOKEN'),
        },
      })
    end,
    gemini_cli = function()
      return require('codecompanion.adapters').extend('gemini_cli', {
        commands = {
          default = { 'gemini', '--experimental-acp' },
        },
        defaults = {
          -- auth_method = "gemini-api-key",
          mcpServers = require('mcphub').get_hub_instance():get_servers(),
          timeout = 20000, -- 20 seconds
        },
      })
    end,
  },
  http = {
    --- Anthropic config for CodeCompanion.
    anthropic = function()
      local anthropic_config = {
        schema = {
          model = {
            default = 'claude-sonnet-4-0',
          },
          auth_type = {
            default = 'oauth',
          },
        },
      }
      return require('codecompanion.adapters').extend('anthropic', anthropic_config)
    end,

    --- OpenAI config for CodeCompanion.
    openai = function()
      local openai_config = {
        opts = {
          stream = false,
        },
        schema = {
          model = {
            default = 'gpt-5-mini-2025-08-07', -- 'gpt-5-2025-08-07',
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
            default = 0.2,
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
          -- temperature = { default = 0.3 },
          -- maxOutputTokens = { default = 8192 },
          model = {
            default = 'moonshotai/kimi-k2-0905',
            choices = {
              'z-ai/glm-4.5',
              'z-ai/glm-4.5-air:free',
              'qwen/qwen3-coder',
              'qwen/qwen3-coder:free',
              'qwen/qwen3-235b-a22b-07-25:free',
              'mistralai/devstral-small:free',
              'moonshotai/kimi-k2:free',
              'moonshotai/kimi-k2-0905',
              'deepseek/deepseek-chat-v3.1',
              'deepseek/deepseek-chat-v3.1:free',
            },
          },
        },
      }
      return require('codecompanion.adapters').extend('openai_compatible', openrouter_config)
    end,

    qwen = function()
      local qwen_config = {
        name = 'qwen',
        formatted_name = 'Qwen',
        env = {
          url = 'https://dashscope-intl.aliyuncs.com/compatible-mode',
          chat_url = '/v1/chat/completions',
          api_key = os.getenv('QWEN_API_KEY'),
        },
        schema = {
          model = {
            default = 'qwen3-coder-plus',
            choices = {
              'qwen3-coder-plus-2025-07-22',
              'qwen3-coder-plus',
              'qwen-turbo-2025-04-28',
            },
          },
          temperature = { default = 0.6 },
          num_ctx = {
            default = 16384,
          },
        },
      }
      return require('codecompanion.adapters').extend('openai_compatible', qwen_config)
    end,
  },
}
