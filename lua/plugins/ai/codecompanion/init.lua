return {
  {
    'ravitemer/codecompanion-history.nvim', -- Save and load conversation history.
    cmd = { 'CodeCompanionHistory', 'CodeCompanionSummaries' },
    config = true,
  },
  {
    'olimorris/codecompanion.nvim',
    version = false,
    dependencies = {
      'j-hui/fidget.nvim',
      'hakonharnes/img-clip.nvim',
      'ravitemer/codecompanion-history.nvim', -- Save and load conversation history.
      'ravitemer/mcphub.nvim', -- Manage MCP servers.
      -- 'jinzhongjia/codecompanion-gitcommit.nvim',
      'lalitmee/codecompanion-spinners.nvim',
      -- 'franco-ruggeri/codecompanion-spinner.nvim', -- for spinner
      'jarmex/codecompanion-gitcommit.nvim',
      -- 'minusfive/codecompanion-agent-rules',
      -- { 'jinzhongjia/codecompanion-tools.nvim' },
    },
    cmd = {
      'CodeCompanionChat',
      'CodeCompanion',
      'CodeCompanionCmd',
      'CodeCompanionActions',
      'CodeCompanionHistory',
    },
    event = 'VeryLazy',
    keys = require('plugins.ai.codecompanion.keymaps'),
    opts = function()
      -- local systemPromptModes = require('plugins.ai.codecompanion.systemprompts.try_sys_prompt')
      local adapters = require('plugins.ai.codecompanion.adapters')
      local display = require('plugins.ai.codecompanion.display')
      local strategies = require('plugins.ai.codecompanion.strategies')

      return {
        adapters = adapters,
        strategies = {
          inline = strategies.inline,
          cmd = strategies.cmd,
          chat = strategies.chat,
        },
        display = {
          diff = display.diff,
          inline = { diff = { enabled = true } },
          chat = display.chat,
          action_palette = display.action_palette,
        },
        memory = {
          opts = {
            chat = {
              enabled = true,
              default_memory = 'default',
              default_params = 'watch',
              condition = function(chat)
                return chat.adapter.type ~= 'acp'
              end,
            },
          },
        },
        prompt_library = require('plugins.ai.codecompanion.promptlibrary'),
        extensions = require('plugins.ai.codecompanion.extensions'),
        opts = {
          system_prompt = require('plugins.ai.codecompanion.systemprompts.my-default').main_system_prompt(),
          send_code = true,
          prompt_decorator = function(message, adapter, _)
            if adapter.model.name == 'qwen3:1.7b' then
              return string.format([[/no_think %s]], message)
            else
              return message
            end
          end,
        },
      }
    end,
    config = function(_, opts)
      require('codecompanion').setup(opts)
      -- Expand `cc` into CodeCompanion in the command line
      vim.cmd([[cab cc CodeCompanion]])
      vim.cmd([[cab ccb CodeCompanionChat anthropic]])

      -- require('plugins.ai.codecompanion.spinner'):init()
      -- Ensure buffer is treated as markdown by treesitter despite being codecompanion filetype
      vim.treesitter.language.register('markdown', 'codecompanion')

      -- Override the default icon for codecompanion filetype
      local devicons = require('nvim-web-devicons')
      devicons.set_icon({
        codecompanion = { icon = ' ' },
      })
      devicons.set_icon_by_filetype({ codecompanion = 'codecompanion' })

      -- codecompanion yolo mode
      vim.g.codecompanion_yolo_mode = true
    end,
  },
}
