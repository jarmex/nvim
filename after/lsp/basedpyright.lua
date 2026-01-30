---@type vim.lsp.Config
local config = {
  settings = {
    basedpyright = {
      disableOrganizeImports = true,
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'workspace',
        typeCheckingMode = 'standard',
        -- diagnosticMode = 'openFilesOnly',
        inlayHints = {
          callArgumentNames = true,
        },
      },
    },
    python = {
      pythonPath = vim.fn.getcwd() .. '/venv/bin/python',
    },
  },
}
return config
