return {
  { 'b0o/SchemaStore.nvim', lazy = true, version = false },
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' }, -- "BufReadPre",
    dependencies = {
      { 'saghen/blink.cmp', enabled = vim.g.cmploader == 'blink.cmp' },
    },
    ---@class PluginLspOpts
    opts = {
      capabilities = {
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
        },
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      },
    },
    ---@param opts PluginLspOpts
    config = function(_, opts)
      -- local capabilities = vim.tbl_deep_extend(
      --   'force',
      --   {},
      --   vim.lsp.protocol.make_client_capabilities(),
      --   require('blink.cmp').get_lsp_capabilities(),
      --   opts.capabilities or {}
      -- )

      local default_server_config = {
        flags = { debounce_text_changes = 150 },
        single_file_support = true,
        -- capabilities = capabilities,
      }

      vim.lsp.config('*', default_server_config)

      require('lspconfig.ui.windows').default_options.border = vim.g.borderStyle

      require('plugins.lsp.lspconfig.attach')
    end,
  },
}
