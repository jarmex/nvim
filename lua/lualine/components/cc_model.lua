-- save to ~/.config/nvim/lua/lualine/components/cc_model.lua

local M = require('lualine.component'):extend()

--
local function get_codecompanion_metadata(bufnr)
  local meta = rawget(_G, 'codecompanion_chat_metadata')
  return type(meta) == 'table' and meta[bufnr] or nil
end

local function format_acp_config_value(opt)
  if not opt or not opt.currentValue then
    return nil
  end

  for _, item in ipairs(opt.options or {}) do
    if item.group then
      for _, value in ipairs(item.options or {}) do
        if value.value == opt.currentValue then
          return value.name or value.value
        end
      end
    elseif item.value == opt.currentValue then
      return item.name or item.value
    end
  end

  return opt.currentValue
end
local function get_live_codecompanion_state(bufnr)
  local out = {}
  local ok, codecompanion = pcall(require, 'codecompanion')
  if not ok or type(codecompanion.buf_get_chat) ~= 'function' then
    return out
  end

  local chat = codecompanion.buf_get_chat(bufnr)
  if not chat then
    return out
  end

  local adapter = chat.adapter or {}
  out.adapter_type = adapter.type

  if adapter.type == 'acp' and chat.acp_connection then
    local models = chat.acp_connection:get_models() or {}
    out.model = models.currentModelId

    for _, opt in ipairs(chat.acp_connection:get_config_options() or {}) do
      if opt.type == 'select' then
        local key = opt.category or opt.id
        if key == 'mode' then
          out.mode = format_acp_config_value(opt)
        elseif key == 'thought_level' then
          out.thought_level = format_acp_config_value(opt)
        end
      end
    end
  else
    out.model = (adapter.defaults and adapter.defaults.model)
      or (adapter.model and adapter.model.id)
      or (adapter.schema and adapter.schema.model and adapter.schema.model.default)
  end

  return out
end
--

local function section_codecompanion(bufnr)
  if vim.bo[bufnr].filetype ~= 'codecompanion' then
    return ''
  end

  local metadata = get_codecompanion_metadata(bufnr)
  local live = get_live_codecompanion_state(bufnr)
  local adapter = metadata and metadata.adapter or {}
  local parts = {}

  local model = live.model or adapter.model
  if model and model ~= '' then
    table.insert(parts, tostring(model))
  end

  local adapter_type = live.adapter_type or adapter.type
  if adapter_type == 'acp' then
    local mode = live.mode
    if not mode and metadata and metadata.config_options and metadata.config_options.mode then
      mode = metadata.config_options.mode.name or metadata.config_options.mode.current
    end
    if mode then
      table.insert(parts, 'mode:' .. mode)
    end

    local thought_level = live.thought_level
    if not thought_level and metadata and metadata.config_options and metadata.config_options.thought_level then
      thought_level = metadata.config_options.thought_level.name or metadata.config_options.thought_level.current
    end
    if thought_level then
      table.insert(parts, 'thought:' .. thought_level)
    end
  end

  if #parts == 0 then
    return ''
  end

  return '󰭻 ' .. table.concat(parts, ' | ')
end

function M:init(options)
  M.super.init(self, options)
end

function M.update_status()
  return section_codecompanion(0)
end

return M
