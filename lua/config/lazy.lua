local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  spec = {
    { import = 'plugins.core' },
    { import = 'plugins.ai' },
    { import = 'plugins.editor' },
    { import = 'plugins.ui' },
    { import = 'plugins.git' },
    { import = 'plugins.coding' },
    { import = 'plugins.snacks' },
    { import = 'plugins.lsp' },
    { import = 'plugins.theme' },
    { import = 'plugins.notes' },
    { import = 'plugins.popup' },
    { import = 'plugins.telescope' },
    { import = 'plugins.misc' },
    { import = 'plugins.terminal' },
    { import = 'plugins.langs' },
  },
  defaults = { lazy = true },
  install = { colorscheme = { 'catppuccin', 'habamax' } },
  checker = {
    enabled = true, -- automatically check for plugin updates
    notify = false, -- done on my own to use minimum condition for less noise
    frequency = 60 * 60 * 24 * 2, -- = 2 days
  },
  change_detection = {
    notify = false,
  },
  ui = {
    border = 'rounded',
    size = {
      width = 0.9,
      height = 0.9,
    },
    title = '💤 Lazy.nvim',
    wrap = false,
    icons = {
      cmd = '  ',
      config = '  ',
      event = '  ',
      ft = '  ',
      init = '  ',
      imports = '  ',
      keys = '  ',
      not_loaded = ' ',
      plugin = '  ',
      runtime = '  ',
      require = '  ',
      source = ' ',
      start = '',
      task = '  ',
    },
    pills = false,
    backdrop = 60,
    custom_keys = {
      ['gi'] = {
        function(plugin)
          local repo = plugin.url:gsub('%.git$', '')
          local line = vim.api.nvim_get_current_line()
          local issue = line:match('#(%d+)')
          local commit = line:match(('%x'):rep(6) .. '+') -- `%x` = hex/hash char
          if not issue and not commit then
            return
          end
          local url = repo .. (issue and '/issues/' .. issue or '/commit/' .. commit)
          vim.ui.open(url)
        end,
        desc = ' Open issue/commit',
      },
    },
  },
  dev = {
    path = '~/Projects/lua',
    patterns = { 'jarmex' },
  },
  diff = {
    cmd = 'diffview.nvim',
  },
  readme = { enabled = true },
  performance = {
    rtp = {
      -- disable unused builtin plugins from neovim
      disabled_plugins = {
        'man',
        'matchparen',
        'matchit',
        'netrw',
        'netrwPlugin',
        'gzip',
        'zip',
        'tar',
        'tarPlugin',
        'tutor',
        'rplugin',
        'health',
        'tohtml',
        'zipPlugin',
      },
    },
  },
})

-- 5s after startup, notify if there many plugin updates
vim.defer_fn(function()
  if not require('lazy.status').has_updates() then
    return
  end
  local threshold = 10
  local numberOfUpdates = tonumber(require('lazy.status').updates():match('%d+'))
  if numberOfUpdates < threshold then
    return
  end
  vim.notify(('󱧕 %s plugin updates'):format(numberOfUpdates), vim.log.levels.INFO, { title = 'Lazy' })
end, 5000)

-- FIX Backdrop
-- PENDING https://github.com/folke/lazy.nvim/issues/1951
vim.api.nvim_create_autocmd('FileType', {
  desc = 'User: fix backdrop for lazy window',
  pattern = 'lazy_backdrop',
  group = group,
  callback = function(ctx)
    local win = vim.fn.win_findbuf(ctx.buf)[1]
    vim.api.nvim_win_set_config(win, { border = 'none' })
  end,
})
