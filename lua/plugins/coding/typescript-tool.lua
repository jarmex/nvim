local filetypes = {
  'javascript',
  'javascriptreact',
  'javascript.jsx',
  'typescript',
  'typescriptreact',
  'typescript.tsx',
  'vue',
}

return {
  'pmizio/typescript-tools.nvim',
  dependencies = { 'neovim/nvim-lspconfig' },
  keys = {
    { '<leader>og', '<cmd>TSToolsOrganizeImports<cr>', desc = 'Organize Imports' },
  },
  ft = filetypes,
  opts = {
    filetypes = filetypes,
    settings = {
      diagnostics = { ignoredCodes = { 2451 } },
      tsserver_file_preferences = {
        importModuleSpecifierPreference = 'non-relative',
        providePrefixAndSuffixTextForRename = false,

        includeInlayEnumMemberValueHints = true,
        includeInlayFunctionLikeReturnTypeHints = false,
        includeInlayFunctionParameterTypeHints = false,
        includeInlayParameterNameHints = 'all', -- none | literals | all
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayVariableTypeHints = false,
        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
        includeCompletionsForModuleExports = true,
      },
      tsserver_plugins = { '@vue/typescript-plugin' },
      tsserver_max_memory = 3072,
      separate_diagnostic_server = true,
      publish_diagnostic_on = 'insert_leave',
      expose_as_code_action = 'all',
      complete_function_calls = true,
      jsx_close_tag = {
        enable = true,
        filetypes = { 'javascriptreact', 'typescriptreact' },
      },
    },
    handlers = {
      ['textDocument/publishDiagnostics'] = function(_, result, ctx, config)
        if result.diagnostics == nil then
          return
        end

        -- ignore some tsserver diagnostics
        local idx = 1
        while idx <= #result.diagnostics do
          local entry = result.diagnostics[idx]

          local formatter = require('format-ts-errors')[entry.code]
          entry.message = formatter and formatter(entry.message) or entry.message

          -- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
          if entry.code == 80001 then
            -- { message = "File is a CommonJS module; it may be converted to an ES module.", }
            table.remove(result.diagnostics, idx)
          else
            idx = idx + 1
          end
        end

        ---@diagnostic disable-next-line: redundant-parameter
        vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
      end,
    },
  },
}
