return {
  hover = true,
  completion = true,
  validate = true,
  -- Have to add this for yamlls to understand that we support line folding
  capabilities = {
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
    },
  },
  filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab', 'yml' },
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = {
      keyOrdering = false,
      format = {
        enable = true,
        printWidth = 120,
        proseWrap = 'always',
      },
      hover = true,
      completion = true,
      validate = { enable = true },
      schemaStore = {
        -- You must disable built-in schemaStore support if you want to use
        -- this plugin and its advanced options like `ignore`.
        enable = false,
        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
        url = '',
        schemas = require('schemastore').yaml.schemas(),
      },
    },
  },
}
