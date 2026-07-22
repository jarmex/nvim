local adapters = require('codecompanion.adapters.acp')

return {
  opts = {
    show_presets = false, -- only show user-defined adapters
    show_model_choices = true, -- show model choices
  },
  ---@type fun (): CodeCompanion.ACPAdapter
  claude_code = function()
    return adapters.extend(
      'claude_code',
      ---@type CodeCompanion.ACPAdapter
      {
        defaults = {
          mcpServers = 'inherit_from_config',
          mode = 'plan',
          timeout = 20000, -- codecompanion's own timeout is 20 seconds for connection init
        },
        env = {
          -- CLAUDE_CODE_OAUTH_TOKEN = token,
          CLAUDE_CODE_OAUTH_TOKEN = 'cmd:cat ~/.claude_code_apitoken',
        },
        -- commands = {
        --   default = { 'bunx', '-y', '--bun', '@agentclientprotocol/claude-agent-acp@v0.29.2' },
        --   yolo = { 'bunx', '-y', '--bun', '@agentclientprotocol/claude-agent-acp@v0.29.2', '--yolo' },
        -- },
      }
    )
  end,
  ---@type fun (): CodeCompanion.ACPAdapter
  gemini_cli = function()
    return adapters.extend('gemini_cli', {
      defaults = {
        timeout = 20000, -- 20 seconds
      },
    })
  end,
  ---@type fun (): CodeCompanion.ACPAdapter
  codex = function()
    return adapters.extend('codex', {
      formatted_name = '\u{E4C6}  Codex',
      defaults = {
        timeout = 20000, -- codecompanion's own timeout is 20 seconds for connection init
        auth_method = 'chat-gpt', -- 'api-key'|'chat-gpt'
        mcpServers = 'inherit_from_config',
      },
    })
  end,
  ---@type fun (): CodeCompanion.ACPAdapter
  copilot_acp = function()
    return adapters.extend('copilot_acp', {
      defaults = {
        timeout = 20000,
        session_config_options = {
          model = 'claude-opus-4-6',
        },
        mcpServers = 'inherit_from_config',
      },
    })
  end,
  ---@type fun (): CodeCompanion.ACPAdapter
  opencode = function()
    return adapters.extend(
      'opencode',
      ---@type CodeCompanion.ACPAdapter
      {
        env = {
          PATH = vim.env['PATH'],
          HOME = vim.env['HOME'],
          USER = vim.env['USER'],
          OPENCODE_CONFIG = vim.fn.expand('~/.config/nvim/utils/agents/opencode/zen.json'),
          OPENCODE_API_KEY = vim.env['NVIM_OPENCODE_ACP_WORK'],
        },
        opts = {
          verbose_output = true,
        },
        defaults = {
          mcpServers = 'inherit_from_config',
          mode = 'plan',
        },
        commands = {
          default = { 'opencode', 'acp' },
        },
      }
    )
  end,
}
