-- local adapters = require('plugins.ai.codecompanion.adapters')
-- local defaultAdapter = os.getenv('NVIM_AI_ADAPTER') or 'copilot'
local systemPromptModes = require('plugins.ai.codecompanion.systemprompts')
local DEFAULT_ADAPTER = 'copilot'
local DEFAULT_MODEL = 'claude-haiku-4.5'
local COPILOT_GPTMODEL = 'gpt-4.1'

--------------------------------------------------------------------------------
--                                                                            --
--  CodeCompanion Strategies Configuration                                    --
--                                                                            --
--  Strategies define how CodeCompanion interacts with different contexts and --
--  how one interacts with CodeCompanion.                                     --
--    - Inline: Direct code modifications within the editor                   --
--    - Chat: Conversational interface with context and tools                 --
--    - Command: Command-line style interactions for quick tasks              --
--                                                                            --
--  This module configures adapters, keymaps, slash commands, and tools       --
--  for each strategy.                                                        --
--                                                                            --
--------------------------------------------------------------------------------

local M = {}

----------------
-- Background --
----------------

M.background = {
  adapter = {
    name = DEFAULT_ADAPTER,
    model = COPILOT_GPTMODEL,
  },
  chat = {
    callbacks = {
      ['on_ready'] = {
        actions = {
          'interactions.background.builtin.chat_make_title',
        },
        enabled = true,
      },
    },
    opts = {
      enabled = true,
    },
  },
}

--------------
--  Inline  --
--------------

M.inline = {
  adapter = { name = DEFAULT_ADAPTER, model = 'gpt-5.1-codex' },
  opts = {
    diff_timeout = 300,
  },
  variables = require('plugins.ai.codecompanion.variables'),
}

------------
--  Chat  --
------------

local extras = [[
  When replying with code, the code must:
- Follow idiomatic patterns and current best practices for the language/framework
- Prefer functional programming patterns: small typed functions, currying/partial application
- Favor composition over inheritance, explicit over implicit
- Functions under 20 lines, max 3 levels nesting
- Extract complex logic into focused helper functions
- Early returns to reduce nesting
- Use current, well-maintained libraries and avoid deprecated patterns
- Use descriptive variable names and small named functions to make code read like English
- Minimal comments, only when non-idiomatic patterns are used and explanation is needed

Extra information:
- current project that you're working on: %s
- current operating system: %s
]]

M.chat = {
  -- adapter = defaultAdapter,
  adapter = {
    name = DEFAULT_ADAPTER,
    model = 'claude-haiku-4.5',
  },
  opts = {
    completion_provider = 'blink', -- blink | cmp | coc | default
    system_prompt = function(ctx)
      return ctx.default_system_prompt .. string.format(extras, ctx.project_root or ctx.cwd, ctx.os or 'unknown')
    end,
    send_code = true,
  },
  roles = {
    llm = function(adapter)
      if adapter.model then
        return string.format('%s (%s)', adapter.formatted_name, adapter.model.name)
      else
        return adapter.formatted_name
      end
    end,
    user = ' Jarmex',
  },
  tools = require('plugins.ai.codecompanion.tools'),
  slash_commands = require('plugins.ai.codecompanion.slash_commands'),
  variables = require('plugins.ai.codecompanion.variables'),
  keymaps = {
    close = { modes = { n = 'q', i = '<C-c>' } },
    -- clear = { modes = { n = '<C-x>' } },
    completion = { modes = { i = '<C-x>' } },
    clear = { modes = { n = 'gcr' } },
    regenerate = { modes = { n = 'gcR' } },
    switch_mode = {
      modes = { n = 'gm' },
      description = 'Switch Chat Mode',
      callback = function()
        systemPromptModes.browse()
      end,
    },
  },
}

---------------
--  Command  --
---------------

M.cmd = {
  adapter = { name = DEFAULT_ADAPTER, model = DEFAULT_MODEL },
}

M.cli = {
  agent = 'claude_code',
  agents = {
    claude_code = {
      cmd = 'claude',
      args = {},
      description = 'Claude Code CLI',
      provider = 'terminal',
    },
    codex = {
      cmd = 'codex',
      args = {},
      description = 'OpenAI Codex CLI',
      provider = 'terminal',
    },
  },
  opts = {
    auto_insert = true, -- Enter insert mode when focusing the CLI terminal
    reload = true, -- Reload buffers when an agent modifies files on disk
  },
}

return M
