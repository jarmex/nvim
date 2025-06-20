local M = {}

function M.load_servers()
  local servers = {}
  local config_path = vim.fn.stdpath('config')
  local langs_dir = config_path .. '/lua/plugins/coding/lsp/langs/'

  -- Get all .lua files in the langs directory
  local files = vim.fn.glob(langs_dir .. '*.lua', false, true)

  for _, file in ipairs(files) do
    local filename = vim.fn.fnamemodify(file, ':t:r') -- Get filename without extension

    -- Skip init.lua to avoid circular dependency
    if filename ~= 'init' then
      local module_path = 'plugins.coding.lsp.langs.' .. filename
      local ok, module = pcall(require, module_path)

      if ok then
        servers[filename] = module
      else
        vim.notify('Failed to load LSP config: ' .. filename, vim.log.levels.WARN)
      end
    end
  end

  return servers
end

return M
