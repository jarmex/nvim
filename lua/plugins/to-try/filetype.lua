-- Set up custom filetypes
vim.filetype.add({
  extension = {
    mdx = 'markdown',
    kbd = 'lisp',
  },
  filename = {
    ['tmux.conf'] = 'bash',
    ['envrc'] = 'sh',
    ['.envrc'] = 'sh',
    ['.env'] = 'sh',
    ['.env.*'] = 'sh',
    ['encore.app'] = 'json',
  },
})

-- Enable spell and wrap for text documents
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Enable wrap and spell for text documents',
  group = vim.api.nvim_create_augroup('auto_spell', { clear = true }),
  pattern = { 'gitcommit', 'text', 'plaintext', 'markdown' },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.wrap = true
  end,
})
