-- Add borders to floating windows
-- vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
--   silent = true,
--   border = vim.g.borderStyle,
-- })

-- vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
--   border = vim.g.borderStyle,
-- })

require('lspconfig.ui.windows').default_options.border = vim.g.borderStyle
