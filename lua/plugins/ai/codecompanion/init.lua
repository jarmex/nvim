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
      -- 'ravitemer/mcphub.nvim', -- Manage MCP servers.
      -- 'jinzhongjia/codecompanion-gitcommit.nvim',
      'lalitmee/codecompanion-spinners.nvim',
      'jarmex/codecompanion-gitcommit.nvim',
      'cairijun/codecompanion-agentskills.nvim',
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

        interactions = {
          inline = strategies.inline,
          cmd = strategies.cmd,
          chat = strategies.chat,
          background = strategies.background,
        },
        display = {
          diff = display.diff,
          inline = { diff = { enabled = true } },
          chat = display.chat,
          action_palette = display.action_palette,
        },
        prompt_library = require('plugins.ai.codecompanion.promptlibrary'),
        extensions = require('plugins.ai.codecompanion.extensions'),
        mcp = require('plugins.ai.codecompanion.mcp').mcpServers,
        opts = {
          log_level = 'DEBUG',
        },
        rules = {
          claude = {
            parser = 'claude',
            description = 'Rule files for claude',
            files = {
              '~/.claude/CLAUDE.md',
              'CLAUDE.md',
            },
          },
          opts = {
            chat = {
              enabled = false,
            },
          },
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

      -- CodeCompanion executes 'checktime' only for the @insert_edit_into_file tool,
      -- but files may also be modified by other tools.
      vim.api.nvim_create_autocmd('WinLeave', {
        desc = 'Reload buffers when leaving CodeCompanion Chat window',
        pattern = '*',
        group = vim.api.nvim_create_augroup('user.cc_checktime', { clear = true }),
        callback = function()
          if vim.bo.filetype == 'codecompanion' then
            vim.cmd('checktime')
          end
        end,
      })
    end,
  },
}
