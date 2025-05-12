local filetypes = {
  'javascript',
  'javascriptreact',
  'javascript.jsx',
  'typescript',
  'typescriptreact',
  'typescript.tsx',
  'vue',
}

return {
  {
    'davidosomething/format-ts-errors.nvim',
    config = function()
      require('format-ts-errors').setup({
        add_markdown = true, -- wrap output with markdown ```ts ``` markers
        start_indent_level = 0, -- initial indent
      })
    end,
  },
  -- add typescript to treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'typescript', 'tsx' })
      end
    end,
  },
  -- Configure nvim-lspconfig to install the server automatically via mason, but
  -- defer actually starting it to our configuration of typescript-tools below.
  {
    'neovim/nvim-lspconfig',
    opts = {
      -- make sure mason installs the server
      servers = {
        ts_ls = {},
      },
      setup = {
        ts_ls = function()
          return true -- avoid duplicate servers
        end,
      },
    },
  },
  {
    'nvim-neotest/neotest',
    optional = true,
    dependencies = {
      { 'nvim-neotest/neotest-jest' },
    },
    keys = {
      {
        '<leader>tw',
        "<cmd>lua require('neotest').run.run({ jestCommand = 'jest --watch ' })<cr>",
        desc = 'Neotest Watch',
      },
    },
    opts = {
      adapters = {
        -- require("neotest-jest")({
        --    jest_test_discovery = false,
        --    jestCommand = require("neotest-jest.jest-util").getJestCommand(vim.fn.expand("%:p:h")) .. " --watch",
        --  }),
        ['neotest-jest'] = {
          jestCommand = 'pnpm jest',
          -- jestConfigFile = "jest.config.js",
          env = { CI = true },
          cwd = function(path)
            return require('lspconfig.util').root_pattern('package.json', 'jest.config.js')(path)
          end,
        },
      },
    },
  },
  {
    'mfussenegger/nvim-dap',
    opts = {
      setup = {
        vscode_js_debug = function()
          local function get_js_debug()
            local install_path = require('mason-registry').get_package('js-debug-adapter'):get_install_path()
            return install_path .. '/js-debug/src/dapDebugServer.js'
          end

          for _, adapter in ipairs({ 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }) do
            require('dap').adapters[adapter] = {
              type = 'server',
              host = 'localhost',
              port = '${port}',
              executable = {
                command = 'node',
                args = {
                  get_js_debug(),
                  '${port}',
                },
              },
            }
          end

          for _, language in ipairs({ 'typescript', 'javascript' }) do
            require('dap').configurations[language] = {
              {
                type = 'pwa-node',
                request = 'launch',
                name = 'Launch file',
                program = '${file}',
                cwd = '${workspaceFolder}',
              },
              {
                type = 'pwa-node',
                request = 'attach',
                name = 'Attach',
                processId = require('dap.utils').pick_process,
                cwd = '${workspaceFolder}',
              },
              {
                type = 'pwa-node',
                request = 'launch',
                name = 'Debug Jest Tests',
                -- trace = true, -- include debugger info
                runtimeExecutable = 'node',
                runtimeArgs = {
                  './node_modules/jest/bin/jest.js',
                  '--runInBand',
                },
                rootPath = '${workspaceFolder}',
                cwd = '${workspaceFolder}',
                console = 'integratedTerminal',
                internalConsoleOptions = 'neverOpen',
              },
              {
                type = 'pwa-chrome',
                name = 'Attach - Remote Debugging',
                request = 'attach',
                program = '${file}',
                cwd = vim.fn.getcwd(),
                sourceMaps = true,
                protocol = 'inspector',
                port = 9222, -- Start Chrome google-chrome --remote-debugging-port=9222
                webRoot = '${workspaceFolder}',
              },
              {
                type = 'pwa-chrome',
                name = 'Launch Chrome',
                request = 'launch',
                url = 'http://localhost:5173', -- This is for Vite. Change it to the framework you use
                webRoot = '${workspaceFolder}',
                userDataDir = '${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir',
              },
            }
          end

          for _, language in ipairs({ 'typescriptreact', 'javascriptreact' }) do
            require('dap').configurations[language] = {
              {
                type = 'pwa-chrome',
                name = 'Attach - Remote Debugging',
                request = 'attach',
                program = '${file}',
                cwd = vim.fn.getcwd(),
                sourceMaps = true,
                protocol = 'inspector',
                port = 9222, -- Start Chrome google-chrome --remote-debugging-port=9222
                webRoot = '${workspaceFolder}',
              },
              {
                type = 'pwa-chrome',
                name = 'Launch Chrome',
                request = 'launch',
                url = 'http://localhost:5173', -- This is for Vite. Change it to the framework you use
                webRoot = '${workspaceFolder}',
                userDataDir = '${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir',
              },
            }
          end
        end,
      },
    },
  },
}
