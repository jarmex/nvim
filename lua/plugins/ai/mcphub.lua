return {
  {
    'ravitemer/mcphub.nvim',
    version = '*',
    enabled = true,
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = { 'MCPHub' },
    build = 'pnpm add -g mcp-hub@latest',
    opts = {
      ui = {
        window = {
          border = vim.g.borderStyle,
        },
        wo = {
          winblend = vim.o.winblend,
          winhl = 'MCPHubMuted:Normal',
        },
      },
    },
    config = function(_, opts)
      require('mcphub').setup(opts)
    end,
  },
}
