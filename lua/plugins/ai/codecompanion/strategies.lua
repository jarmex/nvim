local adapters = require('plugins.ai.codecompanion.adapters')
local defaultAdapter = os.getenv('NVIM_AI_ADAPTER') or 'openai'
local systemPromptModes = require('plugins.ai.codecompanion.systemprompts')

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

--------------
--  Inline  --
--------------

M.inline = {
  adapter = adapters.http.openai,
  opts = {
    diff_timeout = 300,
  },
  variables = require('plugins.ai.codecompanion.variables'),
}

------------
--  Chat  --
------------

M.chat = {
  adapter = defaultAdapter,
  opts = {
    completion_provider = 'blink', -- blink | cmp | coc | default
  },
  roles = {
    ---@type string|fun(adapter: CodeCompanion.HTTPAdapter|CodeCompanion.ACPAdapter): string
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
  adapter = adapters.http.openrouter(),
}

return M
