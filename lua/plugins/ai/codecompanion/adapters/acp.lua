local adapters = require('codecompanion.adapters')

return {
  opts = {
    show_presets = false,
  },
  mcp = require('plugins.ai.codecompanion.mcp').mcpServers,
  claude_code = function()
    return adapters.extend('claude_code', {
      env = {
        CLAUDE_CODE_OAUTH_TOKEN = os.getenv('CLAUDE_CODE_OAUTH_TOKEN'),
      },
      defaults = {
        mcpServers = 'inherit_from_config',
      },
    })
  end,
  gemini_cli = function()
    return adapters.extend('gemini_cli', {
      defaults = {
        timeout = 20000, -- 20 seconds
      },
    })
  end,
  codex = function()
    return require('codecompanion.adapters').extend('codex', {
      formatted_name = '\u{E4C6}  Codex',
      defaults = {
        timeout = 20000, -- codecompanion's own timeout is 20 seconds for connection init
        auth_method = 'chatgpt', -- 'openai-api-key'|'codex-api-key'|'chatgpt'
        mcpServers = 'inherit_from_config',
      },
    })
  end,
  copilot_acp = function()
    return require('codecompanion.adapters').extend('copilot_acp', {
      defaults = {
        timeout = 20000,
        session_config_options = {
          model = 'claude-opus-4-6',
        },
        mcpServers = 'inherit_from_config',
      },
    })
  end,
}
