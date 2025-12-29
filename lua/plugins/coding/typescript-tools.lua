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
  {
    'dmmulroy/ts-error-translator.nvim',
    event = 'VeryLazy',
    opts = {
      auto_attach = true,
      servers = {
        'astro',
        'svelte',
        'ts_ls',
        'typescript-tools',
        'volar',
        'vtsls',
      },
    },
  },
  {
    'davidosomething/format-ts-errors.nvim',
    config = function()
      require('format-ts-errors').setup({
        add_markdown = true, -- wrap output with markdown ```ts ``` markers
        start_indent_level = 0, -- initial indent
      })
    end,
  },
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    ft = filetypes,
    cmd = {
      'TSToolsOrganizeImports',
      'TSToolsSortImports',
      'TSToolsRemoveUnusedImports',
      'TSToolsRemoveUnused',
      'TSToolsAddMissingImports',
      'TSToolsFixAll',
      'TSToolsGoToSourceDefinition',
      'TSToolsFileReferences',
    },
    keys = {
      { '<leader>tt', '', desc = '+ Typescriptreact tool', ft = filetypes },
      { '<leader>ttf', '<cmd>TSToolsFixAll<cr>', desc = 'Fix all', ft = filetypes },
      { '<leader>tts', '<cmd>TSToolsGoToSourceDefinition<cr>', desc = 'Go to source', ft = filetypes },
      { '<leader>ttr', '<cmd>TSToolsFileReferences<cr>', desc = 'File reference', ft = filetypes },
      { '<leader>og', '<cmd>TSToolsOrganizeImports<cr>', desc = 'Organize Imports' },
    },
    opts = {
      filetypes = filetypes,
      settings = {
        diagnostics = { ignoredCodes = { 2451 } },
        tsserver_file_preferences = {
          importModuleSpecifierPreference = 'relative', -- relative | non-relative | project-relative
          providePrefixAndSuffixTextForRename = false,
          quotePreference = 'auto',

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
        tsserver_max_memory = 'auto',
        -- Performance: separate diagnostic server for large projects
        separate_diagnostic_server = true,
        publish_diagnostic_on = 'insert_leave',
        expose_as_code_action = 'all',
        include_completions_with_insert_text = true,
        complete_function_calls = true,
        jsx_close_tag = {
          enable = true,
          filetypes = { 'javascriptreact', 'typescriptreact' },
        },
        tsserver_format_options = {
          insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = true,
          semicolons = 'insert',
          allowIncompleteCompletions = false,
          allowRenameOfImportPath = false,
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
      -- Using Biome to format codes.
      on_attach = function(client, _)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
    },
    config = function(_, opts)
      require('typescript-tools').setup(opts)
    end,
  },
}
--[[
local vuePluginConfig = {
      name = '@vue/typescript-plugin',
      location = vim.fn.expand('$MASON/packages/vue-language-server/node_modules/@vue/language-server'),
      languages = { 'vue' },
      configNamespace = 'typescript',
      enableForWorkspaceTypeScriptVersions = true,
    }
]]
