local function terminal_keymaps()
  return {
    { [[<c-\>]], '<cmd>ToggleTerm<cr>', mode = 'n', desc = 'Toggle Terminal' },
    { '<leader>wt', '<cmd>ToggleTerm<cr>', desc = 'Toggle Terminal' },
    { '<leader>wf', '<cmd>ToggleTerm directio=float<cr>', desc = 'Toggle Floating Terminal' },
    { '<leader>wh', '<cmd>ToggleTerm size=15 direction=horizontal<cr>', desc = 'Toggle Horizontal Terminal' },
    { '<leader>wv', '<cmd>ToggleTerm size=80 direction=vertical<cr>', desc = 'Toggle Vertical Terminal' },
  }
end

return {
  {
    'akinsho/toggleterm.nvim',
    event = 'VeryLazy',
    keys = terminal_keymaps(),
    opts = {
      open_mapping = [[<c-\>]],
      shading_factor = 2,
      direction = 'horizontal',
      -- size = 20,
      size = function(term)
        if term.direction == 'horizontal' then
          return 20
        elseif term.direction == 'vertical' then
          return math.floor(vim.o.columns * 0.4)
        end
      end,
      autochdir = true,
      persist_mode = true,
      insert_mappings = false,
      start_in_insert = true,
      float_opts = {
        border = 'curved',
        winblend = 0,
        highlights = {
          border = 'Normal',
          background = 'Normal',
        },
      },
    },
    config = function(_, opts)
      require('toggleterm').setup(opts)

      local Terminal = require('toggleterm.terminal').Terminal

      local opencode = Terminal:new({
        cmd = 'opencode',
        hidden = true,
        direction = 'float',
        on_open = function(term)
          vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
        end,
      })

      vim.keymap.set('n', '<leader>Ao', function()
        opencode:toggle()
      end, {
        desc = 'ToggleTerm: Open with opencode',
      })
    end,
  },
}
