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
    html = {
      enabled = true,
      tag = {
        buf = { icon = ' ', highlight = 'CodeCompanionChatVariable' },
        file = { icon = ' ', highlight = 'CodeCompanionChatVariable' },
        help = { icon = '󰘥 ', highlight = 'CodeCompanionChatVariable' },
        image = { icon = ' ', highlight = 'CodeCompanionChatVariable' },
        symbols = { icon = ' ', highlight = 'CodeCompanionChatVariable' },
        url = { icon = '󰖟 ', highlight = 'CodeCompanionChatVariable' },
        var = { icon = ' ', highlight = 'CodeCompanionChatVariable' },
        tool = { icon = ' ', highlight = 'CodeCompanionChatTool' },
        user = { icon = ' ', highlight = 'CodeCompanionChatTool' },
        group = { icon = ' ', highlight = 'CodeCompanionChatToolGroup' },
      },
    },
  },
}
