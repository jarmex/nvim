_G.Helpers = require('helpers')

Helpers.safeRequire('config.options') -- early, so available for plugins configs

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
add_filetype()

Helpers.safeRequire('config.lazy')

vim.api.nvim_create_autocmd('InsertEnter', {
  desc = 'User(once): Lazyload spellfixes',
  once = true,
  callback = function()
    Helpers.safeRequire('config.spellfixes')
  end,
})
