return {
  ---@module "lazy.types"
  ---@type LazyPluginSpec
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ft = { 'markdown', 'codecompanion', 'obsidian', 'copilot-chat', 'opencode_output' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      -- preset = 'obsidian',
      quote = {
        repeat_linebreak = true, -- full border on soft-wrap
      },
      completions = {
        blink = { enabled = true },
        lsp = { enabled = true },
      },
      debounce = 250,
      file_types = { 'markdown', 'codecompanion', 'obsidian' },
      -- render_modes = { 'n', 'c', 'i' },
      latex = { enabled = false },
      render_modes = true, -- Render in ALL modes
      -- render_modes = { 'n', 'c', 'i' },
      sign = {
        enabled = false, -- Turn off in the status column
      },
      checkbox = {
        enabled = true,
        -- unchecked = { icon = '󱍫', highlight = 'DiagnosticInfo' },
        -- checked = { icon = '󱍧', highlight = 'DiagnosticOk' },

        checked = { icon = '󰄵' },
        unchecked = { icon = '󰄱' },
        custom = {
          in_progress = { raw = '[+]', rendered = '󱍬', highlight = 'DiagnosticInfo' },
          wont_do = { raw = '[/]', rendered = '󱍮', highlight = 'DiagnosticError' },
          waiting = { raw = '[?]', rendered = '󱍥', highlight = 'DiagnosticWarn' },
          -- todo = { rendered = '◯ ' },
          todo = { rendered = '󰡖', raw = '[-]', highlight = 'RenderMarkdownInfo' },
        },
      },
      pipe_table = {
        border_enabled = true,
        border_virtual = true, -- borders not on empty lines -> preserves blank lines
      },
      heading = {
        position = 'inline', -- = remove indentation of headings
        width = 'block', -- = not full width
        min_width = vim.o.textwidth,
        icons = { '󰎤 ', '󰎧 ', '󰎪 ', '󰎭 ', '󰎱 ', '󰎳 ' }, -- `numeric_x` glyphs
        -- icons = { "󰲠 ", "󰲢 ", "󰲤 ", "󰲦 ", "󰲨 ", "󰲪 " },
      },
      dash = {
        width = vim.o.textwidth,
        priority = 10, -- don't cover codelens from `markdown-oxide` for 1st line of frontmatter
      },
      bullet = {
        icons = { '◇', '▪️', '▫️' }, -- ◆◇•◦▫️▪️
        ordered_icons = '', -- disable overwriting ordered list numbers with 1-2-3
      },
      html = {
        enabled = true,
        comment = {
          text = function(ctx)
            local text = ctx.text:match('^<!%-%-%s*(.-)%s*%-%->$')
            if not text then
              return ''
            end
            return '󰆈 ' .. text:gsub('\n.*', '…')
          end,
        },
        tag = {
          buf = { icon = ' ', highlight = 'CodeCompanionChatVariable' },
          file = { icon = ' ', highlight = 'CodeCompanionChatVariable' },
          -- help = { icon = '󰘥 ', highlight = 'CodeCompanionChatVariable' },
          -- help = { icon = '󰾚 ', highlight = 'CodeCompanionChatVariable' },
          image = { icon = ' ', highlight = 'CodeCompanionChatVariable' },
          symbols = { icon = ' ', highlight = 'CodeCompanionChatVariable' },
          url = { icon = '󰖟 ', highlight = 'CodeCompanionChatVariable' },
          var = { icon = ' ', highlight = 'CodeCompanionChatVariable' },
          tool = { icon = ' ', highlight = 'CodeCompanionChatTool' },
          user = { icon = ' ', highlight = 'CodeCompanionChatTool' },
          group = { icon = ' ', highlight = 'CodeCompanionChatToolGroup' },
          memory = { icon = '󰍛 ', highlight = 'CodeCompanionChatVariable' },
          help = { icon = '󰱼 ', highlight = 'CodeCompanionChatVariable' },
          rules = { icon = '󰺾 ', highlight = 'CodeCompanionChatVariable' },
        },
      },
      overrides = {
        buftype = {
          nofile = {
            render_modes = true,
            sign = { enabled = false },
            padding = { highlight = 'NormalFloat' },
            code = { border = 'hide', style = 'normal' },
          },
        },
      },
      -- restart_highlighter = true,
    },
  },
}
