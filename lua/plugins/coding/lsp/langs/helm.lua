vim.filetype.add({
  pattern = {
    ['.*/templates/.*%.yaml'] = 'helm',
  },
})

-- vim.api.nvim_create_autocmd('BufEnter', {
--   pattern = { '*.yaml', '*.yml' },
--   callback = function()
--     if vim.fn.filereadable(vim.fn.expand('%:h') .. '/Chart.yaml') then
--       vim.bo.filetype = 'helm'
--     end
--   end,
-- })

return {
  -- 'neovim/nvim-lspconfig',
  -- opts = {
  --   servers = {
  --     helm = {},
  --   },
  -- },
}
