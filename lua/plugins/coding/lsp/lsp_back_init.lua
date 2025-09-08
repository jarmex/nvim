return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' }, -- "BufReadPre",
  dependencies = {
    { 'b0o/SchemaStore.nvim', lazy = true, version = false },
    'mason-org/mason-lspconfig.nvim', -- Updated repo URL
  },
  opts = {
    setup = {},
    servers = {},
  },
  config = function(_, opts)
    local servers = opts.servers

    local function serverSetup(server)
      local server_opts = servers[server] or {}
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      local has_blink, blink = pcall(require, 'blink.cmp')
      capabilities = vim.tbl_deep_extend('force', capabilities, has_blink and blink.get_lsp_capabilities() or {}, {
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
      })

      if opts.setup[server] then
        if opts.setup[server](server, server_opts) then
          return
        end
      elseif opts.setup['*'] then
        if opts.setup['*'](server, server_opts) then
          return
        end
      end
      require('lspconfig')[server].setup(server_opts)
    end

    require('lspconfig.ui.windows').default_options.border = vim.g.borderStyle
    for server, server_opts in pairs(servers) do
      if server_opts then
        server_opts = server_opts == true and {} or server_opts
        serverSetup(server)
      end
    end
  end,
}
