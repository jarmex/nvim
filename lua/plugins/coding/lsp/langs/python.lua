return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        pyright = {},
        basedpyright = {
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = 'openFilesOnly',
            typeCheckingMode = 'standard',
            inlayHints = {
              callArgumentNames = 'all',
              functionReturnTypes = true,
              pytestParameters = true,
              variableTypes = true,
              genericTypes = true,
              useTypingExtensions = true,
            },
            autoFormatStrings = true,
            autoImportCompletions = true,
          },
          linting = { enabled = false },
          disableOrganizeImports = true,
        },
        ruff = {
          keys = {
            {
              '<leader>co',
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { 'source.organizeImports' },
                    diagnostics = {},
                  },
                })
              end,
              desc = 'Organize Imports',
            },
          },
        },
      },
    },
  },
}
