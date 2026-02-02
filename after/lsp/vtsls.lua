-- local vls_bin = vim.fn.exepath('vue-language-server')
-- local vls_dir = vls_bin:gsub('/bin/vue%-language%-server', '/lib/node_modules/@vue/language-server')
local constants = require('helpers.constants')

local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vim.fn.stdpath('data') .. '/mason/packages/vue-language-server/node_modules/@vue/language-server',
  languages = { 'vue' },
  configNamespace = 'typescript',
}

---@type vim.lsp.Config
local config = {
  settings = {
    complete_function_calls = true,
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      experimental = {
        maxInlayHintLength = 30,
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
      tsserver = {
        globalPlugins = {
          vue_plugin,
        },
      },
    },
    typescript = {
      importModuleSpecifier = 'relative',
      updateImportsOnFileMove = { enabled = 'always' },
      suggest = {
        completeFunctionCalls = true,
      },
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = 'literals' },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = false },
      },
    },
    javascript = {
      importModuleSpecifier = 'relative',
      updateImportsOnFileMove = { enabled = 'always' },
      suggest = {
        completeFunctionCalls = true,
      },
      implicitProjectConfig = {
        checkJs = true,
        strictNullChecks = false,
        strictFunctionTypes = false,
      },
      lib = {
        'ES2020',
        'DOM',
      },
    },
  },
  filetypes = constants.javascript_aliases,
}

return config
