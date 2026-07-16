local root_files = {
  'pyproject.toml',
  'ruff.toml',
  '.ruff.toml',
  'requirements.txt',
  'uv.lock',
  'setup.py',
  'setup.cfg',
  'Pipfile',
  'pyrightconfig.json',
  '.git',
}

---@type vim.lsp.Config
local config = {
  root_markers = root_files,
  filetypes = { 'python' },
  settings = {
    basedpyright = {
      disableOrganizeImports = true,
      analysis = {
        -- NOTE: uncomment this to ignore linting. Good for projects where
        -- basedpyright lights up as a christmas tree.
        -- ignore = { "*" },
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        typeCheckingMode = 'basic', -- standard | basic | off
        reportUnannotatedClassAttribute = false,
        -- diagnosticMode = 'workspace',
        diagnosticMode = 'openFilesOnly',
        inlayHints = {
          callArgumentNames = true,
        },
      },
    },
    python = {
      -- pythonPath = vim.fn.getcwd() .. '/venv/bin/python',
      venvPath = os.getenv('VIRTUAL_ENV'),
      pythonPath = vim.fn.exepath('python'),
    },
  },
}
return config
