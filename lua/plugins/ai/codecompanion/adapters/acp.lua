local adapters = require('codecompanion.adapters')

return {
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
  codex = function()
    return require('codecompanion.adapters').extend('codex', {
      defaults = {
        auth_method = 'openai-api-key', -- "openai-api-key"|"codex-api-key"|"chatgpt"
      },
    })
  end,
}
