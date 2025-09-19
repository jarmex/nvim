local filetypes = {
  'javascript',
  'javascriptreact',
  'javascript.jsx',
  'typescript',
  'typescriptreact',
  'typescript.tsx',
  'vue',
}

local mason_path = vim.fn.stdpath('data') .. '/mason/packages/'

return {
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
    event = 'BufEnter',
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
        tsserver_max_memory = 'auto',
        separate_diagnostic_server = true,
        publish_diagnostic_on = 'insert_leave',
        expose_as_code_action = 'all',
        include_completions_with_insert_text = true,
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
      -- Using Biome to format codes.
      on_attach = function(client, _)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
    },
    keys = {
      { '<leader>og', '<cmd>TSToolsOrganizeImports<cr>', desc = 'Organize Imports' },
    },
    config = function(_, opts)
      require('typescript-tools').setup(opts)
    end,
  },
}
