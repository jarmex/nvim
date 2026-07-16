local adapters = require('codecompanion.adapters')

return {
  opts = {
    show_presets = false,
  },
  claude_code = function()
    -- local home = vim.fn.expand('~')
    -- local file_path = vim.fn.fnamemodify(home .. '/.claude_code_apitoken', ':p')
    --
    -- -- Read the token directly using Lua instead of shell commands
    -- local token = ''
    -- local f = io.open(file_path, 'r')
    -- if f then
    --   -- Read entire file and trim any whitespace/newlines
    --   token = f:read('*a'):gsub('%s+', '')
    --   f:close()
    -- else
    --   vim.notify('Could not find Claude Code token at ' .. file_path, vim.log.levels.WARN)
    -- end

    return require('codecompanion.adapters').extend('claude_code', {
      defaults = { mcpServers = 'inherit_from_config' },
      env = {
        -- CLAUDE_CODE_OAUTH_TOKEN = token,
        CLAUDE_CODE_OAUTH_TOKEN = 'cmd:cat ~/.claude_code_apitoken',
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
