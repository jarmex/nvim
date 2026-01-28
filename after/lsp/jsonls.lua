---@type vim.lsp.Config
return {
  init_options = {
    provideFormatter = false,
    documentRangeFormattingProvider = false,
  },
  settings = {
    json = {
      validate = { enable = true },
      schemas = require('schemastore').json.schemas(),
    },
  },
  filetypes = { 'json', 'jsonc', 'json5' },
}
