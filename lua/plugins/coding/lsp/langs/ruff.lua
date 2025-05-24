local has_black = vim.fn.executable('black') == 1

return {
  capabilities = Helpers.lsp.create_capabilities({
    textDocument = {
      formatting = { dynamicRegistration = not has_black },
      rangeFormatting = { dynamicRegistration = not has_black },
    },
  }),
  init_options = {
    settings = {
      configurationPreference = 'filesystemFirst',
      logLevel = 'error',
    },
  },
  cmd_env = { RUFF_TRACE = 'messages' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml' },
}
