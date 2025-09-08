local util = require('lspconfig.util')

-- Auto goimports with gopls
-- https://github.com/neovim/nvim-lspconfig/issues/115#issuecomment-1128115341
-- https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-imports
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.go' },
  callback = function()
    local params = vim.lsp.util.make_range_params()
    local wait_ms = 500
    params.context = { only = { 'source.organizeImports' } }
    local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, wait_ms)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or 'utf-16'
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
  end,
})

return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      ---@type lspconfig.options
      servers = {
        golangci_lint_ls = {
          cmd = { 'golangci-lint-langserver' },
          filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
          root_dir = util.root_pattern('go.work', 'go.mod', '.git'),
        }, -- linter
        gopls = {
          cmd = { 'gopls' },
          filetypes = { 'go', 'gomod', 'gowork', 'gotmpl', 'gosum' },
          root_dir = util.root_pattern('go.work', 'go.mod', '.git'),
          keys = {
            -- Workaround for the lack of a DAP strategy in neotest-go: https://github.com/nvim-neotest/neotest-go/issues/12
            -- { "<leader>td", "<cmd>lua require('dap-go').debug_test()<CR>", desc = "Debug Nearest (Go)" },
          },
          settings = {
            -- main readme: https://github.com/golang/tools/blob/master/gopls/doc/features/README.md
            --
            -- for all options, see:
            -- https://github.com/golang/tools/blob/master/gopls/doc/vim.md
            -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
            -- for more details, also see:
            -- https://github.com/golang/tools/blob/master/gopls/internal/settings/settings.go
            -- https://github.com/golang/tools/blob/master/gopls/README.md
            env = {
              GOEXPERIMENT = 'rangefunc',
            },
            gopls = {
              -- https://github.com/golang/tools/blob/master/gopls/internal/settings/settings.go
              gofumpt = true, -- for conform set this to false
              codelenses = {
                gc_details = true, -- Show a code lens toggling the display of gc's choices.
                generate = true, -- show the `go generate` lens.
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = { -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              -- https://github.com/golang/tools/blob/master/gopls/doc/inlayHints.md
              -- check if this works?
              ['ui.inlayhint.hints'] = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeValuesTypes = true,
              },
              analyses = {
                fieldalignment = false,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
                shadow = true,
                unusedvariable = true,
                fillreturns = true,
                nonewvars = true,
                undeclaredname = true,
                unreachable = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              directoryFilters = { '-**/node_modules', '-**/.git', '-.vscode', '-.idea', '-.vscode-test' },
              -- https://github.com/golang/tools/blob/master/gopls/internal/settings/settings.go
              semanticTokens = false, -- disabling this enables treesitter injections (for sql, json etc)
              symbolMatcher = 'fuzzy',
              buildFlags = { '-tags', 'integration' },
              diagnosticsDelay = '500ms',
              matcher = 'Fuzzy',

              -- diagnostic options
              -- https://github.com/golang/tools/blob/master/gopls/internal/settings/settings.go
              staticcheck = true,
              vulncheck = 'imports',
              analysisProgressReporting = true,
            },
          },
        },
      },
    },
  },

  {
    'maxandron/goplements.nvim',
    ft = 'go',
    opts = {},
  },

  {
    'ray-x/go.nvim',
    lazy = true,
    enabled = false,
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
}
