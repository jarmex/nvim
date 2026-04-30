return {
  {
    'Davidyz/VectorCode',
    version = '*',
    build = 'uv tool upgrade "vectorcode[lsp,mcp]"',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = 'VectorCode',
    opts = {
      async_backend = 'lsp',
      on_setup = { lsp = true },
    },
  },
}
