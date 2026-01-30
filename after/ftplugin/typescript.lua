-- inherit all javascript settings
vim.cmd.source(vim.fn.stdpath('config') .. '/after/ftplugin/javascript.lua')

-- sets `errorformat` for quickfix-list
vim.cmd.compiler('tsc')
vim.opt_local.makeprg = 'pnpm dlx tsc --noEmit'

vim.keymap.set('n', '<leader>ri', function()
  vim.lsp.buf.code_action({
    context = { only = { 'source.fixAll.biome' } },
    apply = true,
  })
end, { desc = '[R]emove unused [I]mports with Biome' })
