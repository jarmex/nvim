return {
  {
    'ravitemer/mcphub.nvim',
    version = '*',
    enabled = true,
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = { 'MCPHub' },
    -- build = 'npm install -g mcp-hub@latest',
    build = 'bundled_build.lua',
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
      use_bundled_binary = true,
    },
    config = function(_, opts)
      require('mcphub').setup(opts)
    end,
  },
}
