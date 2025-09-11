local M = {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    opts = {
      flavour = 'macchiato',
      transparent_background = true,
      dim_inactive = {
        enabled = false,
        percentage = 0.05,
      },
      term_colors = true,
      compile = {
        compile_path = vim.fn.stdpath('cache') .. '/catppuccin',
        suffix = '_compiled',
      },
      styles = {
        variables = { 'italic' },
        operators = { 'italic' },
      },
      default_integrations = {
        blink_cmp = { style = 'solid' },
        diffview = true,
        fidget = true,
        fzf = true,
        headlines = true,
        hop = true,
        -- lspsaga = true,
        mason = true,
        mini = { enabled = true },
        native_lsp = { enabled = true },
        -- navic = { enabled = true },
        nvimtree = true,
        -- nvim_surround = true,
        rainbow_delimiters = true,
        snacks = { enabled = true },
        which_key = true,
      },
      integrations = {
        alpha = true,
        lsp_trouble = true,
        mini = true,
        -- blink_cmp = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { 'italic' },
            hints = { 'italic' },
            warnings = { 'italic' },
            information = { 'italic' },
          },
          underlines = {
            errors = { 'undercurl' },
            hints = { 'undercurl' },
            warnings = { 'undercurl' },
            information = { 'undercurl' },
          },
          inlay_hints = { background = false },
        },
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        -- navic = { enabled = false, custom_bg = 'lualine' },
        mason = true,
        dap = {
          enabled = true,
          enable_ui = true,
        },
        indent_blankline = {
          enabled = false,
          colored_indent_levels = true,
        },
        dashboard = true,
        bufferline = true,
        markdown = true,
        neotest = true,
        notify = true,
        noice = true,
        illuminate = true,
        telescope = { enabled = true },
        treesitter = true,
        treesitter_context = true,
        snacks = {
          enabled = true,
          indent_scope_color = 'surface2',
        },
        semantic_tokens = true,
        which_key = true,
        render_markdown = true,
        flash = false,
      },
      custom_highlights = function(colors)
        return {
          -- FloatBorder = { fg = colors.mantle, bg = colors.mantle },
          -- FloatTitle = { fg = colors.lavender, bg = colors.mantle },
          LspInfoBorder = { fg = colors.mantle, bg = colors.mantle },
          LspInlayHint = { style = { 'italic' } }, -- italicize lsp inlay hints
          WinSeparator = { bg = colors.base, fg = colors.lavender },
          PmenuThumb = { bg = colors.blue },
          DapUIFloatBorder = { link = 'FloatBorder' },
          CodeiumSuggestion = { fg = colors.blue },
        }
      end,
    },
    config = function(plugin, opt)
      vim.opt.background = 'dark'
      require(plugin.name).setup(opt)
      -- vim.api.nvim_command 'colorscheme catppuccin'
      -- vim.cmd.colorscheme('catppuccin')
      vim.api.nvim_set_hl(0, 'CursorColumn', { link = 'CursorLine' })

      local palette = require('catppuccin.palettes').get_palette('macchiato')
      vim.cmd.colorscheme('catppuccin-macchiato')

      -- Telescope highlights to match editor background
      vim.api.nvim_set_hl(0, 'TelescopeNormal', { bg = palette.base })
      vim.api.nvim_set_hl(0, 'TelescopeBorder', { fg = palette.blue, bg = palette.base })
      vim.api.nvim_set_hl(0, 'TelescopePromptNormal', { bg = palette.base })
      vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { fg = palette.blue, bg = palette.base })
      vim.api.nvim_set_hl(0, 'TelescopeResultsNormal', { bg = palette.base })
      vim.api.nvim_set_hl(0, 'TelescopeResultsBorder', { fg = palette.blue, bg = palette.base })
      vim.api.nvim_set_hl(0, 'TelescopePreviewNormal', { bg = palette.base })
      vim.api.nvim_set_hl(0, 'TelescopePreviewBorder', { fg = palette.blue, bg = palette.base })
      vim.api.nvim_set_hl(0, 'TelescopeTitle', { fg = palette.mauve, bg = palette.base })
      vim.api.nvim_set_hl(0, 'TelescopePromptTitle', { fg = palette.mauve, bg = palette.base })
      vim.api.nvim_set_hl(0, 'TelescopeResultsTitle', { fg = palette.mauve, bg = palette.base })
      vim.api.nvim_set_hl(0, 'TelescopePreviewTitle', { fg = palette.mauve, bg = palette.base })

      -- Hide all semantic highlights until upstream issues are resolved (https://github.com/catppuccin/nvim/issues/480)
      for _, group in ipairs(vim.fn.getcompletion('@lsp', 'highlight')) do
        vim.api.nvim_set_hl(0, group, {})
      end
    end,
  },
}

return M
