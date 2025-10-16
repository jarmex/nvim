local adapters = require('codecompanion.adapters')

---@module "codecompanion"
---@type CodeCompanion.Config
return {
  http = {
    --- Anthropic config for CodeCompanion.
    anthropic = function()
      local anthropic_config = {
        formatted_name = 'Anthropic Claude Sonnet 4.5',
        -- headers = {
        --   ['anthropic-beta'] = 'context-1m-2025-08-07',
        -- },
        schema = {
          model = {
            default = 'claude-sonnet-4-5-20250929',
          },
          -- thinking_budget = {
          --   default = 63000,
          -- },
          auth_type = {
            default = 'oauth',
          },
        },
      }
      return adapters.extend('anthropic', anthropic_config)
    end,

    --- OpenAI config for CodeCompanion.
    openai_gpt_5 = function()
      return adapters.extend('openai_responses', {
        name = 'openai_gpt_5',
        -- env = { api_key = OPENAI_API_KEY },
        schema = {
          model = {
            default = 'gpt-5',
            choices = {
              ['gpt-5'] = {
                opts = {
                  has_vision = true,
                  can_reason = true,
                  stream = true,
                },
              },
            },
          },
          ['reasoning.effort'] = { default = 'minimal' },
          verbosity = { default = 'low' },
        },
      })
    end,
    openai_response = function()
      return adapters.extend('openai_responses', {
        opts = {
          stream = false,
        },
        schema = {
          model = {
            default = 'gpt-5-codex',
            choices = {
              ['gpt-5-codex'] = {
                opts = {
                  has_vision = true,
                  can_reason = true,
                  stream = true,
                },
              },
              ['gpt-5'] = {
                opts = {
                  has_vision = true,
                  can_reason = true,
                  stream = true,
                },
              },
            },
          },
          ['reasoning.effort'] = { default = 'minimal' },
        },
      })
    end,

    openai = function()
      local openai_config = {
        opts = {
          stream = false,
        },
        schema = {
          model = {
            default = 'gpt-4.1-mini-2025-04-14', -- 'gpt-5-2025-08-07',
          },
        },
      }
      return adapters.extend('openai', openai_config)
    end,

    openrouter = function()
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
            default = 'z-ai/glm-4.6',
            choices = {
              'z-ai/glm-4.6',
              'x-ai/grok-code-fast-1',
              'deepseek/deepseek-v3.2-exp',
              'qwen/qwen3-coder',
              'qwen/qwen3-coder:free',
              'moonshotai/kimi-k2-0905',
              'deepseek/deepseek-v3.1-terminus',
              'mistralai/devstral-small:free',
              'moonshotai/kimi-k2:free',
              'openai/gpt-oss-120b:free',
              'qwen/qwen3-235b-a22b-07-25:free',
              'x-ai/grok-4-fast:free',
            },
          },
        },
      }
      return adapters.extend('openai_compatible', openrouter_config)
    end,

    deepseek = function()
      return adapters.extend('deepseek', {
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
      return adapters.extend('ollama', {
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
      return adapters.extend('gemini', gemini_config)
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
      return adapters.extend('openai_compatible', qwen_config)
    end,
  },
  acp = {
    claude_code = function()
      return adapters.extend('claude_code', {
        env = {
          CLAUDE_CODE_OAUTH_TOKEN = os.getenv('CLAUDE_CODE_OAUTH_TOKEN'),
        },
      })
    end,
    gemini_cli = function()
      return adapters.extend('gemini_cli', {
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
}
