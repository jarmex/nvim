local opt = vim.opt_local

-- opt.colorcolumn = { '60', '82' }
opt.colorcolumn = { '82' }
opt.expandtab = true
-- opt.formatoptions = opt.formatoptions - 'o' -- don't continue comments on `o` and `O`
opt.list = false
opt.number = false
opt.relativenumber = false
opt.shiftwidth = 4
opt.softtabstop = 4
opt.tabstop = 4
opt.spell = true

vim.keymap.set('n', 'gcm', [[:CodeCompanionGitCommit<CR>]], {
  desc = 'Generate Commit Msg',
  buffer = true,
  silent = true,
})
