-- CodeCompanion Display Configuration

local M = {}

-- Action Palette

M.action_palette = {
  width = 95,
  height = 20,
  prompt = 'Prompt ',
  provider = 'snacks', -- default|telescope|mini_pick
  opts = {
    show_default_actions = true,
    show_default_prompt_library = true,
  },
}

-- Diff Provider

M.diff = {
  enabled = true,
  close_chat_at = 240,
  layout = 'vertical', -- vertical|horizontal
  opts = {
    'internal',
    'filler',
    'closeoff',
    'algorithm:histogram',
    'indent-heuristic',
    'followwrap',
    'linematch:120',
  },
  provider = 'inline', -- mini_diff|split|inline
}

-- Chat Window
M.chat = {
  show_settings = false,
  show_token_count = false,
  start_in_insert_mode = false,
  -- auto_scroll = true,
  -- fold_context = true,
  -- child_window = { opts = { wrap = true } },
  icons = {
    tool_success = '󰸞 ',
    pinned_buffer = ' ',
    watched_buffer = '👀 ',
  },

  debug_window = {
    ---@return number|fun(): number
    width = vim.o.columns - 5,
    ---@return number|fun(): number
    height = vim.o.lines - 2,
  },

  window = {
    width = 0.60,
    layout = vim.o.columns >= 120 and 'vertical' or 'horizontal',
    position = nil,
    -- border = 'single',
    -- height = 0.8,
    -- relative = 'editor',
    opts = {
      -- breakindent = true,
      -- cursorcolumn = false,
      -- cursorline = false,
      number = false,
      relativenumber = false,
      -- foldcolumn = '0',
      -- linebreak = true,
      -- list = false,
      -- numberwidth = 1,
      signcolumn = 'no',
      -- spell = false,
      -- wrap = true,
      winbar = '',
      statuscolumn = ' ',
      winfixbuf = true,
      scrolloff = 3,
    },
  },
}

return M
