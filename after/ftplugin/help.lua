local bkeymap = require('lib.utils').bufKeymap

vim.diagnostic.enable(false, { bufnr = 0 })
-- vim.opt_local.colorcolumn = ''
vim.opt_local.wrap = true

-- `gO` opens the heading-selection in vim help files. Only used for txt-help
-- files, so lazy-generated md help files are not affected
local ext = vim.api.nvim_buf_get_name(0):match('%.(%w+)$')
if ext == 'txt' then
  bkeymap('n', 'gs', 'gO', { remap = true })
end
