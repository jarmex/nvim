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
      'jinzhongjia/codecompanion-gitcommit.nvim',
      {
        'franco-ruggeri/codecompanion-spinner.nvim',
        event = 'VeryLazy',
        -- opts = {
        --   style = 'fidget', -- "spinner", "fidget", or "none"
        -- },
      }, -- for spinner
      -- 'jarmex/codecompanion-gitcommit.nvim',
      -- 'minusfive/codecompanion-agent-rules',
      -- { 'jinzhongjia/codecompanion-tools.nvim' },
    },
    cmd = { 'CodeCompanionChat', 'CodeCompanion', 'CodeCompanionCmd', 'CodeCompanionActions', 'CodeCompanionHistory' },
    event = 'VeryLazy',
    keys = require('plugins.ai.codecompanion.keymaps'),
    opts = function()
      -- local systemPromptModes = require('plugins.ai.codecompanion.systemprompts')
      local adapters = require('plugins.ai.codecompanion.adapters')
      local display = require('plugins.ai.codecompanion.display')
      local strategies = require('plugins.ai.codecompanion.strategies')

      -- systemPromptModes.setup()

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
        prompt_library = require('plugins.ai.codecompanion.promptlibrary'),
        extensions = require('plugins.ai.codecompanion.extensions'),
        -- opts = {
        -- local system_prompt = require("codecompanion.config").config.opts.system_prompt
        -- system_prompt = systemPromptModes.beast_prompt,
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
