return {
  'akinsho/nvim-bufferline.lua',
  enabled = true,
  version = '*',
  event = 'VeryLazy',
    -- stylua: ignore
    keys = {
      { "[b",         "<cmd>BufferLineCyclePrev<cr>",                              desc = "Previous" },
      { "]b",         "<cmd>BufferLineCycleNext<cr>",                              desc = "Next" },
      { "<leader>bq", "<cmd>BufferLineCloseLeft<cr><cmd>BufferLineCloseRight<cr>", desc = "Close All Tabs" },
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>",                              desc = "Toggle pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>",                   desc = "Delete non-pinned buffers" },
      { "<leader>bt", "<cmd>BufferLinePick<cr>",                                   desc = "Pick Tab" },
      { '<leader>bl', '<cmd>BufferLineCloseLeft<cr>',                              desc = 'Close buffers to the left' },
      { '<leader>br', '<cmd>BufferLineCloseRight<cr>',                             desc = 'Close buffers to the right' },
      { '<leader>bc', '<cmd>BufferLinePickClose<cr>',                              desc = 'Select a buffer to close' },
    },
  opts = function()
    local icons = require('helpers.icons')
    return {
      options = {
        -- -- stylua: ignore
        -- close_command = function(n) Snacks.bufdelete(n) end,
        -- -- stylua: ignore
        -- right_mouse_command = function(n) Snacks.bufdelete(n) end,
        numbers = 'none', -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
        show_close_icon = false,
        always_show_bufferline = false,
        show_buffer_close_icons = false,
        show_buffer_icons = true,
        diagnostics = 'nvim_lsp',
        separator_style = 'thin',
        show_tab_indicators = true,
        -- To close the Tab command, use moll/vim-bbye's :Bdelete command here
        close_command = 'Bdelete! %d',
        right_mouse_command = 'Bdelete! %d',
        diagnostics_indicator = function(_, _, diag)
          local diagnostic_icons = icons.diagnostics
          local ret = (diag.error and diagnostic_icons.Error .. diag.error .. ' ' or '')
            .. (diag.warning and diagnostic_icons.Warning .. diag.warning or '')
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = 'NvimTree',
            text = 'File Explorer',
            highlight = 'Directory',
            text_align = 'center',
            padding = 1,
          },
          {
            filetype = 'snacks_layout_box',
          },
          { filetype = 'codecompanion', text = 'CodeCompanion', text_align = 'center' },
          { filetype = 'Outline', text = 'OUTLINE', text_align = 'center' },
        },
      },
    }
  end,
  config = function(_, opts)
    require('bufferline').setup(opts)
    -- Fix bufferline when restoring a session
    vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete' }, {
      callback = function()
        vim.schedule(function()
          pcall(nvim_bufferline)
        end)
      end,
    })
  end,
}
