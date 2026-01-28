---@type vim.lsp.Config
return {
  filetypes = { 'bash', 'sh' },
  settings = {
    bashIde = {
      globPattern = '*@(.sh|.inc|.bash|.command)',
    },
  },
}
