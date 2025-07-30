return {
  {
    'olimorris/codecompanion.nvim',
    version = false,
    dependencies = {
      'j-hui/fidget.nvim',
      'ravitemer/codecompanion-history.nvim',
      'hakonharnes/img-clip.nvim',
      -- 'jarmex/codecompanion-gitcommit.nvim',
      'jinzhongjia/codecompanion-gitcommit.nvim',
      -- 'minusfive/codecompanion-agent-rules',
      -- { 'jinzhongjia/codecompanion-tools.nvim' },
      { 'franco-ruggeri/codecompanion-spinner.nvim', event = 'VeryLazy' }, -- for spinner
    },
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
            opts = {
              completion_provider = 'blink', -- blink|cmp|coc|default
            },
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
            icons = {
              tool_success = '󰸞',
            },
            show_settings = false,
            render_headers = false,
            show_header_separator = true,
            show_references = true,
            show_token_count = true,
            auto_scroll = true,
            -- start_in_insert_mode = true,
            window = {
              width = 0.60,
              -- layout = 'vertical',
              layout = vim.o.columns >= 120 and 'vertical' or 'horizontal',
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
            provider = 'default', -- Can be "default", "telescope", or "mini_pick". If not specified, the plugin will autodetect installed providers.
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
      -- vim.cmd([[cab ccb CodeCompanionChat anthropic]])

      -- require('plugins.ai.codecompanion.spinner'):init()
      -- Ensure buffer is treated as markdown by treesitter despite being codecompanion filetype
      vim.treesitter.language.register('markdown', 'codecompanion')

      -- Override the default icon for codecompanion filetype
      local devicons = require('nvim-web-devicons')
      devicons.set_icon({
        codecompanion = { icon = ' ' },
      })
      devicons.set_icon_by_filetype({ codecompanion = 'codecompanion' })
    end,
  },
  -- {
  --   'folke/snacks.nvim',
  --   opts = function()
  --     -- see:
  --     -- - https://github.com/olimorris/codecompanion.nvim/discussions/813#discussioncomment-13081665
  --     -- - https://github.com/olimorris/dotfiles/blob/16a503b14e75c9d5dfc973f2ee9e7aa2523e8a97/.config/nvim/lua/plugins/custom/spinner.lua
  --     vim.api.nvim_create_autocmd('User', {
  --       pattern = { 'CodeCompanionRequestStarted', 'CodeCompanionRequestStreaming', 'CodeCompanionRequestFinished' },
  --       group = vim.api.nvim_create_augroup('codecompanion_snacks_notifier', {}),
  --       callback = function(ev)
  --         local msg
  --         if ev.match == 'CodeCompanionRequestStarted' then
  --           msg = '  Sending...'
  --         elseif ev.match == 'CodeCompanionRequestStreaming' then
  --           msg = '  Generating...'
  --         elseif ev.data.status == 'success' then
  --           msg = '  Completed'
  --         elseif ev.data.status == 'error' then
  --           msg = '  Failed'
  --         else
  --           msg = '󰜺  Cancelled'
  --         end
  --
  --         local title
  --         local adapter = ev.data.adapter
  --         if adapter then
  --           title = adapter.formatted_name
  --             .. (adapter.model and adapter.model ~= '' and ' (' .. adapter.model .. ')' or '')
  --         else
  --           title = 'CodeCompanion'
  --         end
  --
  --         vim.notify(msg, vim.log.levels.INFO, {
  --           id = 'codecompanion_status',
  --           title = title,
  --           timeout = 500,
  --           keep = function()
  --             return ev.match ~= 'CodeCompanionRequestFinished'
  --           end,
  --           opts = function(notif)
  --             notif.icon = ev.match == 'CodeCompanionRequestFinished' and ' ' or Snacks.util.spinner()
  --           end,
  --         })
  --       end,
  --     })
  --   end,
  -- },
}
