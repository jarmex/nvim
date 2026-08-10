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
    pyright = { disableOrganizeImports = true },
    python = {
      pythonPath = vim.fn.exepath('python3'),
      analysis = { ignore = { '*' }, diagnosticMode = 'off', typeCheckingMode = 'off' },
    },
  },
}
return config
