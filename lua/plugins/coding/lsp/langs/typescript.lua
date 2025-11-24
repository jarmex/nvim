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
