return {
  {
    'maxandron/goplements.nvim',
    ft = 'go',
    opts = {},
  },

  {
    'ray-x/go.nvim',
    lazy = true,
    dependencies = { -- optional packages
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('go').setup({
        lsp_inlay_hints = {
          enable = false,
        },
        dap_debug = false,
        dap_debug_gui = false,
        run_in_floaterm = true,
        luasnip = false,
        dap_debug_keymap = false,
        lsp_codelens = false,
        lsp_keymaps = false,
        diagnostic = false,
        test_runner = 'ginkgo',
        lsp_document_formatting = false,
      })
    end,
    event = { 'CmdlineEnter' },
    keys = {
      { '<leader>tgn', '<cmd>GinkgoFunc<CR>', desc = 'Run nearest test' },
      { '<leader>tgr', '<cmd>GoRun<CR>', desc = 'Run Go main' },
      { '<leader>tgf', '<cmd>GoTestFile<CR>', desc = 'Run test file' },
    },
    ft = { 'go', 'gomod' },
    -- build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  },

  -- {
  --   'nvim-neotest/neotest',
  --   optional = true,
  --   dependencies = {
  --     { 'jarmex/neotest-ginkgo' },
  --     -- {
  --     --   'fredrikaverpil/neotest-golang',
  --     --   -- enabled = false,
  --     --   version = '*',
  --     --   dependencies = {
  --     --     'leoluz/nvim-dap-go',
  --     --   },
  --     -- },
  --   },
  --   opts = {
  --     adapters = {
  --       ['neotest-ginkgo'] = {
  --         -- Here we can set options for neotest-go, e.g.
  --         -- args = { "-tags=integration" }
  --         --   args = { "-count=1", "-timeout=60s", "-race", "-cover" },
  --         experimental = {
  --           test_table = true,
  --         },
  --       },
  --       -- ['neotest-golang'] = {
  --       --   args = { "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out" },
  --       --   experimental = {
  --       --     test_table = true,
  --       --   },
  --       -- },
  --     },
  --   },
  -- },
}
