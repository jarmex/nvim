_G.Helpers = require('helpers')

Helpers.safeRequire('config.options') -- early, so available for plugins configs

local disable_distribution_plugins = function()
  vim.g.loaded_gzip = 1
  vim.g.loaded_tar = 1
  vim.g.loaded_tarPlugin = 1
  vim.g.loaded_zip = 1
  vim.g.loaded_zipPlugin = 1
  vim.g.loaded_getscript = 1
  vim.g.loaded_getscriptPlugin = 1
  vim.g.loaded_vimball = 1
  vim.g.loaded_vimballPlugin = 1
  vim.g.loaded_matchit = 1
  vim.g.loaded_matchparen = 1
  vim.g.loaded_2html_plugin = 1
  vim.g.loaded_logiPat = 1
  vim.g.loaded_rrhelper = 1
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
  vim.g.loaded_netrwSettings = 1
  vim.g.loaded_netrwFileHandlers = 1
  vim.g.skip_ts_context_commentstring_module = true
end

local disable_providers = function()
  local default_providers = {
    'node',
    'perl',
    'python3',
    'ruby',
  }

  for _, provider in ipairs(default_providers) do
    vim.g['loaded_' .. provider .. '_provider'] = 0
  end
end

local add_filetype = function()
  vim.filetype.add({
    filename = {
      Brewfile = 'ruby',
      ['.bash_aliases'] = 'bash',
      ['.bash_functions'] = 'bash',
      ['.bash_profile'] = 'bash',
      ['.bashrc'] = 'bash',
      ['.shell_platform'] = 'bash',
      ['.zprofile'] = 'zsh',
      ['.zsh_functions'] = 'zsh',
      ['.zshenv'] = 'zsh',
      ['.zshrc'] = 'zsh',
      ['.zsh_copilot'] = 'zsh',
      ['~/.config/ghostty/config'] = 'toml',
    },
    pattern = {
      ['*.jsonc'] = 'jsonc',
      ['tsconfig.json'] = 'jsonc',
      ['tsconfig*.json'] = 'jsonc',
      ['%.env%.[%w_.-]+'] = 'sh',
    },
    extension = {
      hurl = 'hurl',
    },
  })
end

local leader_map = function()
  vim.api.nvim_set_keymap('n', '<Space>', '', { noremap = true })
  vim.api.nvim_set_keymap('x', '<Space>', '', { noremap = true })
  vim.g.maplocalleader = ' '
  vim.g.mapleader = ' '
end

leader_map()

Helpers.safeRequire('config.keymaps')
Helpers.safeRequire('config.commands')
Helpers.safeRequire('config.autocmds')

disable_providers()
disable_distribution_plugins()
add_filetype()

Helpers.safeRequire('config.lazy')

vim.api.nvim_create_autocmd('InsertEnter', {
  desc = 'User(once): Lazyload spellfixes',
  once = true,
  callback = function()
    Helpers.safeRequire('config.spellfixes')
  end,
})
