-- DOCS https://github.com/Microsoft/vscode/tree/main/extensions/json-language-features/server#configuration
--------------------------------------------------------------------------------

return {
  -- Disable formatting in favor of biome
  init_options = { provideFormatter = false, documentRangeFormattingProvider = false },
  capabilities = Helpers.lsp.create_capabilities({
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true,
        },
      },
    },
  }),
  on_init = function(client)
    Helpers.lsp.on_init(client, {
      json = {
        format = {
          enable = true,
        },
        schemas = require('schemastore').json.schemas(),
        validate = { enable = true },
      },
    })
  end,
  -- settings = {
  --   json = {
  --     format = {
  --       enable = true,
  --     },
  --     validate = { enable = true },
  --     schemas = require('schemastore').json.schemas(),
  --   },
  -- },
}
