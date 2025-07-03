-- adapted from https://github.com/johnsaigle/nvim/blob/main/lua/custom/plugins/codecompanion.lua#L100

local M = {}

-- Fabric pattern loader functions
local fabric_dir = vim.fn.expand('~/.config/fabric/patterns')

-- Helper function to check if a file exists
local function file_exists(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == 'file'
end

-- Helper function to read file contents
local function read_file(path)
  local file = io.open(path, 'r')
  if not file then
    return nil
  end
  local content = file:read('*all')
  file:close()
  return content
end
-- Create a short name for slash commands
local function create_short_name(name)
  return name:gsub('[^%w]', ''):lower()
end

local function scan_patterns_dir(dir)
  local handle = vim.loop.fs_scandir(dir)
  if not handle then
    return {}
  end

  local patterns = {}
  while true do
    local name, type = vim.loop.fs_scandir_next(handle)
    if not name then
      break
    end

    if type == 'directory' then
      local system_file = dir .. '/' .. name .. '/system.md'
      if file_exists(system_file) then
        table.insert(patterns, {
          name = name,
          path = system_file,
        })
      end
    end
  end

  return patterns
end

-- Convert fabric pattern name to a more readable format
local function format_pattern_name(name)
  local formatted = name:gsub('[_-]', ' ')
  formatted = formatted:gsub('(%l)(%w*)', function(a, b)
    return string.upper(a) .. b
  end)
  return formatted
end

-- Load fabric patterns and return them as CodeCompanion prompts
function M.load_fabric_patterns()
  -- Check if fabric patterns directory exists
  local stat = vim.loop.fs_stat(fabric_dir)
  if not stat or stat.type ~= 'directory' then
    vim.notify('Fabric patterns directory not found: ' .. fabric_dir, vim.log.levels.WARN)
    return {}
  end

  local patterns = scan_patterns_dir(fabric_dir)
  local prompt_library = {}

  for _, pattern in ipairs(patterns) do
    local system_content = read_file(pattern.path)
    if system_content then
      -- Clean up the system content
      system_content = system_content:gsub('^%s+', ''):gsub('%s+$', '')

      local formatted_name = format_pattern_name(pattern.name)
      local short_name = create_short_name(pattern.name)

      -- Create the prompt entry for CodeCompanion
      prompt_library['Fabric: ' .. formatted_name] = {
        strategy = 'chat',
        description = 'Fabric pattern: ' .. pattern.name,
        opts = {
          short_name = short_name,
          is_slash_cmd = true,
          auto_submit = false,
          user_prompt = false,
        },
        prompts = {
          {
            role = 'system',
            content = system_content,
          },
          {
            role = 'user',
            content = function(context)
              -- If text is selected, include it in the prompt
              if context.is_visual then
                local text = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)
                return "Here's the content I'd like you to analyze:\n\n```"
                  .. context.filetype
                  .. '\n'
                  .. text
                  .. '\n```'
              else
                return '<user_prompt>Please provide your input:</user_prompt>'
              end
            end,
            opts = {
              contains_code = true,
            },
          },
        },
      }
    end
  end

  return prompt_library
end

return M
