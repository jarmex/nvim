return {
  filetypes = { 'python' },
  capabilities = Helpers.lsp.create_capabilities(),
  workspace_required = false,
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'openFilesOnly',
        typeCheckingMode = 'standard',
        inlayHints = {
          callArgumentNames = 'all',
          functionReturnTypes = true,
          pytestParameters = true,
          variableTypes = true,
          genericTypes = true,
          useTypingExtensions = true,
        },
        autoFormatStrings = true,
        autoImportCompletions = true,
      },
      linting = { enabled = false },
      disableOrganizeImports = true,
    },
  },
}
