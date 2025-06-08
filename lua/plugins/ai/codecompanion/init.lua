return {
  'olimorris/codecompanion.nvim',
  version = false,
  dependencies = { 'j-hui/fidget.nvim', 'ravitemer/codecompanion-history.nvim' },
  cmd = { 'CodeCompanionChat', 'CodeCompanion', 'CodeCompanionCmd', 'CodeCompanionActions', 'CodeCompanionHistory' },
  event = 'VeryLazy',
  keys = require('plugins.ai.codecompanion.keymaps'),
  opts = function()
    local defaultAdapter = os.getenv('NVIM_AI_ADAPTER') or 'gemini'
    local helper = require('plugins.ai.codecompanion.helper')
    local systemPromptModes = require('plugins.ai.codecompanion.systemprompts')
    local adapters = require('plugins.ai.codecompanion.adapters')

    systemPromptModes.setup()

    return {
      adapters = adapters,
      strategies = {
        inline = { adapter = adapters.openai },
        cmd = { adapter = adapters.deepseek },
        chat = {
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
          adapter = defaultAdapter,
          roles = helper.roles(),
          tools = require('plugins.ai.codecompanion.tools'),
          slash_commands = require('plugins.ai.codecompanion.slash_commands'),
        },
      },
      display = {
        diff = {
          close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
          layout = 'vertical', -- vertical|horizontal split for default provider
          opts = { 'internal', 'filler', 'closeoff', 'algorithm:patience', 'followwrap', 'linematch:120' },
          -- opts = { 'vertical', 'internal', 'filler', 'closeoff', 'algorithm:histogram', 'linematch:120', 'iwhiteall' },
          provider = 'mini_diff', -- default|mini_diff
        },
        inline = { diff = { enabled = true } },
        chat = {
          show_settings = false,
          render_headers = false,
          show_header_separator = true,
          show_references = true,
          show_token_count = true,
          auto_scroll = true,
          window = {
            layout = 'vertical',
            opts = {
              number = false,
              relativenumber = false,
              winbar = '',
              statuscolumn = ' ', -- just for padding
            },
          },
        },
        action_palette = {
          prompt = 'Prompt ', -- Prompt used for interactive LLM calls
          provider = 'snacks', -- Can be "default", "telescope", or "mini_pick". If not specified, the plugin will autodetect installed providers.
          opts = {
            show_default_actions = true, -- Show the default actions in the action palette?
            show_default_prompt_library = true, -- Show the default prompt library in the action palette?
          },
        },
      },
      prompt_library = require('plugins.ai.codecompanion.promptlibrary'),
      extensions = require('plugins.ai.codecompanion.extensions'),
      -- opts = {
      -- local system_prompt = require("codecompanion.config").config.opts.system_prompt
      --   system_prompt = require('plugins.ai.codecompanion.system_prompt'),
      -- },
    }
  end,
  config = function(_, opts)
    -- vim.g.codecompanion_auto_tool_mode = true
    require('codecompanion').setup(opts)
    -- Expand `cc` into CodeCompanion in the command line
    vim.cmd([[cab cc CodeCompanion]])
    vim.cmd([[cab ccb CodeCompanionChat anthropic]])

    require('plugins.ai.codecompanion.spinner'):init()
  end,
}
