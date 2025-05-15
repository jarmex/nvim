-- DOCS https://github.com/neoclide/coc-css#configuration-options
--------------------------------------------------------------------------------

return {
  -- using `biome` instead (this key overrides `settings.format.enable = true`)
  init_options = { provideFormatter = false },
  filetypes = { 'css', 'scss', 'less' },
  settings = {
    css = {
      validate = true,
      lint = {
        vendorPrefix = 'ignore', -- needed for scrollbars
        duplicateProperties = 'warning',
        zeroUnits = 'warning',
        emptyRules = 'warning',
        importStatement = 'warning',
        fontFaceProperties = 'warning',
        hexColorLength = 'warning',
        argumentsInColorFunction = 'warning',
        unknownAtRules = 'warning',
        ieHack = 'warning',
        propertyIgnoredDueToDisplay = 'warning',
      },
    },
    scss = { validate = false },
    less = { validate = false },
  },
}
