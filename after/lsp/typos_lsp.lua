-- DOCS https://github.com/tekumara/typos-lsp/blob/main/docs/neovim-lsp-config.md
--------------------------------------------------------------------------------

return {
  init_options = { diagnosticSeverity = 'Hint' },
  filetypes = {
    'css',
    'go',
    'html',
    'javascript',
    'javascript.jsx',
    'javascriptreact',
    'json',
    'jsonc',
    'lua',
    'make',
    'markdown',
    'python',
    'typescript',
    'typescript.tsx',
    'typescriptreact',
    'yaml',
    'yml',
  },
}
