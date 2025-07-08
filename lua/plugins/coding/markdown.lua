return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  ft = { 'markdown', 'codecompanion' },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    completions = {
      lsp = {
        enabled = true,
      },
    },
    file_types = { 'markdown', 'codecompanion' },
    latex = { enabled = false },
    render_modes = true, -- Render in ALL modes
    -- render_modes = { 'n', 'c', 'i' },
    sign = {
      enabled = false, -- Turn off in the status column
      exclude = {
        buftypes = { 'nofile' },
      },
    },
    checkbox = {
      enabled = true,
      unchecked = { icon = '󱍫', highlight = 'DiagnosticInfo' },
      checked = { icon = '󱍧', highlight = 'DiagnosticOk' },
      custom = {
        in_progress = { raw = '[+]', rendered = '󱍬', highlight = 'DiagnosticInfo' },
        wont_do = { raw = '[/]', rendered = '󱍮', highlight = 'DiagnosticError' },
        waiting = { raw = '[?]', rendered = '󱍥', highlight = 'DiagnosticWarn' },
        todo = { rendered = '◯ ' },
      },
    },
    overrides = {
      filetype = {
        codecompanion = {
          html = {
            tag = {
              buf = { icon = ' ', highlight = 'CodeCompanionChatIcon' },
              file = { icon = ' ', highlight = 'CodeCompanionChatIcon' },
              group = { icon = ' ', highlight = 'CodeCompanionChatIcon' },
              help = { icon = '󰘥 ', highlight = 'CodeCompanionChatIcon' },
              image = { icon = ' ', highlight = 'CodeCompanionChatIcon' },
              symbols = { icon = ' ', highlight = 'CodeCompanionChatIcon' },
              tool = { icon = '󰯠 ', highlight = 'CodeCompanionChatIcon' },
              url = { icon = '󰌹 ', highlight = 'CodeCompanionChatIcon' },
            },
          },
        },
      },
    },
  },
}
