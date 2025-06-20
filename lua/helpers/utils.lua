local M = {}

---Check if a plugin has been loaded
---@param plugin string # The name of the plugin. It should be the same as the one you use in `require(plugin name)`
---@return boolean available # Whether the plugin is available
function M.is_available(plugin)
  return package.loaded[plugin] ~= nil
end

function M.debounce(ms, fn)
  local timer = assert(vim.uv.new_timer())
  return function(...)
    local argc, argv = select('#', ...), { ... }
    timer:start(ms, 0, function()
      timer:stop()
      vim.schedule(function()
        fn(unpack(argv, 1, argc))
      end)
    end)
  end
end

---sets `buffer`, `silent` and `nowait` to true
---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param opts? {desc?: string, unique?: boolean, buffer?: number|boolean, remap?: boolean, silent?:boolean, nowait?: boolean}
function M.bufKeymap(mode, lhs, rhs, opts)
  opts = vim.tbl_extend('force', { buffer = true, silent = true, nowait = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

---ensures unique keymaps https://www.reddit.com/r/neovim/comments/16h2lla/can_you_make_neovim_warn_you_if_your_config_maps/
---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param opts? {desc?: string, unique?: boolean, buffer?: number|boolean, remap?: boolean, silent?:boolean, nowait?: boolean}
function M.uniqueKeymap(mode, lhs, rhs, opts)
  if not opts then
    opts = {}
  end

  -- allow to disable with `unique=false` to overwrites nvim defaults: https://neovim.io/doc/user/vim_diff.html#default-mappings
  if opts.unique == nil then
    opts.unique = true
  end

  -- violating `unique=true` throws error; using `pcall` to still load other mappings
  pcall(vim.keymap.set, mode, lhs, rhs, opts)
end
return M
