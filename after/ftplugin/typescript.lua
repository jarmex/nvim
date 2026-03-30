-- inherit all javascript settings
vim.cmd.source(vim.fn.stdpath('config') .. '/after/ftplugin/javascript.lua')

-- sets `errorformat` for quickfix-list
vim.cmd.compiler('tsc')
vim.opt_local.makeprg = 'pnpm dlx tsc --noEmit'
