local adapters = require('codecompanion.adapters')

-- local adapter = { name = "openai_responses", model = "gpt-5-mini" }
local reasoningEffort = 'minimal' -- minimal|low|medium|high https://platform.openai.com/docs/api-reference/responses/create#responses_create-reasoning

return {
  --- Anthropic config for CodeCompanion.
  anthropic = function()
    local anthropic_config = {
      formatted_name = 'Claude 4.5',
      -- headers = {
      --   ['anthropic-beta'] = 'context-1m-2025-08-07',
      -- },
      schema = {
        model = {
          default = 'claude-haiku-4-5-20251001',
          choices = {
            ['claude-sonnet-4-5-20250929'] = {
              opts = {
                can_reason = true,
                has_vision = true,
                max_output = 64000,
                context_window = 1000000,
                description = 'High-performance model - Balanced performance and capability',
              },
            },
            ['claude-haiku-4-5-20251001'] = {
              opts = {
                can_reason = true,
                has_vision = true,
                max_output = 64000,
                context_window = 200000,
                description = 'Our latest Claude Haiku model - Balanced performance and capability',
              },
            },
          },
        },
        -- thinking_budget = {
        --   default = 63000,
        -- },
        auth_type = {
          default = 'oauth',
        },
        extended_thinking = {
          default = true,
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
      opts = { stream = false },
      schema = {
        model = {
          choices = {
            ['gpt-5-mini'] = { opts = { can_reason = true } },
            ['gpt-5-nano'] = { opts = { can_reason = true } },
          },
        },
        ['reasoning.effort'] = { default = reasoningEffort },

        -- PENDING https://github.com/olimorris/codecompanion.nvim/pull/2561
        ['reasoning.summary'] = {
          enabled = function()
            return false
          end,
        }, -- requires organizational access
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

  openrouter = require('plugins.ai.codecompanion.adapters.openrouter'),

  ['deepseek-chat'] = function()
    return require('codecompanion.adapters.http').extend('deepseek', {
      schema = { model = { default = 'deepseek-chat' } },
    })
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
  default_copilot = function()
    require('codecompanion.adapters').extend('copilot', {
      schema = {
        model = {
          order = 1,
          type = 'enum',
          desc = 'Select one of your curated Copilot-backed models',
          -- default = "claude-sonnet-4",
          default = 'claude-sonnet-4.5',
          choices = {
            ['claude-sonnet-4.5'] = { opts = { provider = 'anthropic' } },
            ['gpt-5-2025-08-07'] = { opts = { provider = 'openai', tier = 'flagship' } },
            ['o4-mini'] = { opts = { provider = 'openai', can_reason = true, reasoning_tier = 'mini' } },
            ['gemini-2.5-pro'] = { opts = { provider = 'google', multimodal = true } },
          },
        },
      },
    })
  end,
}
