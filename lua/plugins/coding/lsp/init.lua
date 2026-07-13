return {
  {
    'qvalentin/helm-ls.nvim',
    ft = 'helm',
    opts = {},
  },
  {
    'neovim/nvim-lspconfig',
    cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'https://codeberg.org/mfussenegger/nvim-dap',
      { 'b0o/SchemaStore.nvim', lazy = true, version = false },
    },
    config = function()
      require('plugins.coding.lsp.lsp_border')

      -- This should be executed before you configure any language server
      --
      local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
      lsp_capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }
      -- Enable file watching for LSP
      -- It's disabled because the default implementation is considered slow.
      lsp_capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

      local has_blink, blink = pcall(require, 'blink.cmp')
      lsp_capabilities =
        vim.tbl_deep_extend('force', lsp_capabilities, has_blink and blink.get_lsp_capabilities() or {}, {
          textDocument = {
            foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true,
            },
          },
        })

      vim.lsp.config('*', {
        capabilities = lsp_capabilities,
      })

      vim.lsp.enable({
        'basedpyright',
        'bashls',
        'biome',
        'cssls',
        'cucumber_language_server',
        'docker_compose_language_service',
        'dockerls',
        'emmet_language_server',
        'gopls',
        'golangci_lint_ls',
        'harper_ls',
        'helm_ls',
        'jsonls',
        'lua_ls',
        'ruff',
        'taplo',
        'typos_lsp',
        'vue_ls',
        'yamlls',
        -- 'ts_ls',
      })

      -- Enable codelens globally
      vim.lsp.codelens.enable(true)

      require('plugins.coding.lsp.keymaps')

      vim.lsp.config('copilot', {
        settings = {
          telemetry = {
            -- doesn't work, seems to be a vscode setting
            telemetryLevel = 'off',
          },
        },
      })

      require('plugins.coding.lsp.diagnostics')

      -- disable lsp for .env files
      local group = vim.api.nvim_create_augroup('__env', { clear = true })
      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = { '*.env', '.env*' },
        group = group,
        callback = function(args)
          vim.cmd([[set filetype=sh]]) -- set ft to sh to enable syntax highlighting
          vim.diagnostic.enable(false, { bufnr = args.buf })
        end,
      })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp_attach_server_caps', { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client == nil then
            return
          end
          if client.name == 'ruff' then
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
          end

          -- if client.name == 'yamlls' then
          --   -- Need this so that conform uses LSP to format yaml.* files.
          --   client.server_capabilities.documentFormattingProvider = true
          -- end

          if client.name == 'vue_ls' then
            -- Disable rename in hybrid mode (vtsls handles it)
            client.server_capabilities.renameProvider = false
          end

          -- Prevent LSP from attaching to virtual buffers such as diffview.
          -- local bufname = vim.api.nvim_buf_get_name(args.buf)
          -- if bufname:match('^diffview://') then
          --   vim.schedule(function()
          --     vim.lsp.buf_detach_client(args.buf, args.data.client_id)
          --   end)
          -- end
        end,
      })
    end,
  },
}
