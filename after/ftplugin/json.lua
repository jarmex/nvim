function JsonFolds()
  local line = vim.fn.getline(vim.v.lnum)
  -- let l:lline = split(l:line, '\zs')
  local inc = vim.fn.count(line, '{')
  local dec = vim.fn.count(line, '}')
  local level = inc - dec
  if level == 0 then
    return '='
  elseif level > 0 then
    return 'a' .. level
  elseif level < 0 then
    return 's' .. -level
  end
end

vim.opt.foldlevel = 3
vim.opt_local.conceallevel = 0
vim.opt_local.foldnestmax = 5
vim.opt_local.foldmethod = 'marker'
vim.opt_local.foldmarker = '{,}'

vim.opt_local.foldmethod = 'expr'
vim.opt_local.foldexpr = 'v:lua.JsonFolds()'
vim.opt_local.foldenable = false

local bkeymap = require('helpers.utils').bufKeymap

bkeymap('n', '<leader>rp', '<cmd>%! jq .<CR>', { desc = ' Prettify Buffer' })
bkeymap('n', '<leader>rm', '<cmd>%! jq --compact-output .<CR>', { desc = ' Minify Buffer' })
bkeymap('n', 'o', function()
  local line = vim.api.nvim_get_current_line()
  if line:find('[^,{[]$') then
    return 'A,<cr>'
  end
  return 'o'
end, { expr = true, desc = ' Auto-add comma on `o`' })
