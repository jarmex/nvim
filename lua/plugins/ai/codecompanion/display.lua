-- CodeCompanion Display Configuration

local M = {}

-- Action Palette

M.action_palette = {
  width = 95,
  height = 20,
  prompt = 'Prompt ',
  provider = 'snacks', -- default|telescope|mini_pick
  opts = {
    show_preset_actions = true,
    show_default_prompt_library = true,
  },
}

-- Diff Provider

M.diff = {
  enabled = true,
  provider = 'inline', -- mini_diff|split|inline
  provider_opts = {
    split = {
      close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
      layout = 'vertical', -- vertical|horizontal split
      opts = {
        'internal',
        'filler',
        'closeoff',
        'algorithm:histogram',
        'indent-heuristic',
        'followwrap',
        'linematch:120',
      },
    },
    inline = {
      layout = 'float', -- float|buffer - Where to display the diff
      show_keymap_hints = true, --
      show_removed = true, --
    },
  },
}

-- Chat Window
M.chat = {
  show_settings = false,
  show_token_count = false,
  show_reasoning = false,
  fold_reasoning = true,
  show_tools_processing = true,
  start_in_insert_mode = false,
  auto_scroll = true,
  fold_context = true,
  -- floating_window = { opts = { wrap = true } },
  icons = {
    -- tool_success = '󰸞 ',
    pinned_buffer = ' ',
    watched_buffer = '👀 ',
    chat_context = '📎️',
    buffer_sync_all = '󰪴 ',
    buffer_sync_diff = ' ',
    -- chat_context = " ",
    chat_fold = ' ',
    tool_pending = '  ',
    tool_in_progress = '  ',
    tool_failure = '  ',
    tool_success = '  ',
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
    position = 'right',
    sticky = true,
    opts = {
      -- breakindent = true,
      -- cursorcolumn = false,
      cursorline = true,
      number = false,
      relativenumber = false,
      -- foldcolumn = '0',
      -- linebreak = true,
      -- list = false,
      -- numberwidth = 1,
      signcolumn = 'no',
      spell = false,
      -- wrap = true,
      winbar = '',
      statuscolumn = ' ',
      winfixbuf = true,
      scrolloff = 3,
      -- allow folding codeblocks
      -- foldlevel = 1,
      -- foldmethod = 'expr',
      -- foldexpr = 'v:lua.vim.treesitter.foldexpr()', -- allow folding codeblocks
    },
  },
}

return M
