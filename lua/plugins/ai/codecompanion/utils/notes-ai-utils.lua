-- from https://github.com/3ZsForInsomnia/dotfiles/blob/b9592b901be95d3ee74386fe4eb42ff20749ce6a/neovim/.config/nvim/lua/config/notes-ai-utils.lua
local M = {}

local function is_ignored(path)
  local ignore_patterns = {
    '%.git/',
    'node_modules/',
    'venv/',
    '%.obsidian/',
    '%.trash/',
  }

  for _, pattern in ipairs(ignore_patterns) do
    if path:match(pattern) then
      return true
    end
  end
  return false
end

function M.open_recent_notes(days, target_dir)
  days = tonumber(days) or 7
  target_dir = target_dir or vim.fn.getcwd()
  local current_time = os.time()
  local files_to_open = {}

  -- Use find to get all markdown files with modification time
  local find_cmd = string.format('find "%s" -type f -name "*.md" -newermt "%d days ago" 2>/dev/null', target_dir, days)
  local handle = io.popen(find_cmd)
  if not handle then
    print('Error: Could not execute find command')
    return
  end

  for file in handle:lines() do
    if not is_ignored(file) then
      local stat = vim.loop.fs_stat(file)
      if stat and stat.mtime then
        local age_days = (current_time - stat.mtime.sec) / (60 * 60 * 24)
        if age_days <= days then
          table.insert(files_to_open, file)
        end
      end
    end
  end
  handle:close()

  if #files_to_open > 0 then
    -- Open each file in a new buffer
    for _, file in ipairs(files_to_open) do
      vim.cmd('edit ' .. vim.fn.fnameescape(file))
    end
    print(('Opened %d markdown files modified within last %d days.'):format(#files_to_open, days))
  else
    print('No markdown files modified within the specified window!')
  end
end

function M.setup()
  vim.api.nvim_create_user_command('OpenRecentNotes', function(opts)
    M.open_recent_notes(opts.fargs[1], opts.fargs[2])
  end, {
    desc = 'Open recently edited markdown files in buffers',
    nargs = '*',
    complete = 'file',
  })
end

return M
