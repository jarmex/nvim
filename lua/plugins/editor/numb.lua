return {
  -- display line numbers while going to a line with `:`
  'nacro90/numb.nvim',
  event = 'CmdlineEnter',
  opts = {
    show_numbers = true, -- Enable 'number' for the window while peeking
    show_cursorline = true, -- Enable 'cursorline' for the window while peeking
  },
}
