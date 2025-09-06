-- CodeCompanion Display Configuration

local M = {}

-- Action Palette

M.action_palette = {
  width = 95,
  height = 15,
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
  render_headers = false,
  -- show_header_separator = true,
  -- separator = '─',
  -- show_references = true,
  show_settings = false,
  -- show_token_count = false,
  start_in_insert_mode = false,
  -- auto_scroll = true,
  fold_context = true,
  child_window = { opts = { wrap = true } },
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
    border = 'single',
    -- height = 0.8,
    relative = 'editor',
    opts = {
      breakindent = true,
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
    },
  },

  ---@param tokens number
  ---@param adapter table
  ---@return string
  token_count = function(tokens, adapter)
    local total = type(tokens) == 'number' and tokens or 0
    local budget = adapter and adapter.schema and adapter.schema.max_tokens and adapter.schema.max_tokens.default
      or 4096
    if type(budget) == 'function' then
      budget = budget(adapter)
    end
    if not budget or type(budget) ~= 'number' then
      budget = 4096
    end
    if total > budget then
      return string.format(' Estimated tokens (%d) exceed context window (%d)', total, budget)
    end
    local percent = math.min(total / budget, 1)
    local bar_len = 20
    local filled = math.floor(percent * bar_len)
    local empty = bar_len - filled
    local bar = string.rep('█', filled) .. string.rep('░', empty)
    return string.format('%s | %d/%d tokens used', bar, total, budget)
  end,
}

return M
