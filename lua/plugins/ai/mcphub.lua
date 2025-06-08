return {
  {
    'ravitemer/mcphub.nvim',
    version = '*',
    enabled = true,
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>$', '<Cmd>MCPHub<CR>', desc = 'Open MCB Hub' },
    },
    cmd = { 'MCPHub' },
    -- build = 'npm install -g mcp-hub@latest',
    build = 'bundled_build.lua',
    opts = {
      use_bundled_binary = true,
      auto_toggle_mcp_servers = false,
      ui = {
        window = {
          border = vim.g.borderStyle,
          width = 0.9,
          height = 0.9,
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
