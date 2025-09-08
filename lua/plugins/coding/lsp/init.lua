return {
  {
    'neovim/nvim-lspconfig',
    cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'mfussenegger/nvim-dap',
      'nanotee/sqls.nvim',
      { 'b0o/SchemaStore.nvim', lazy = true, version = false },
    },
    config = function()
      require('plugins.coding.lsp.lsp_border')

      -- This should be executed before you configure any language server
      --
      -- Also support UFO: lsp-zero.netlify.app/docs/guide/quick-recipes.html#enable-folds-with-nvim-ufo
      local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
      lsp_capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      local lspconfig_defaults = require('lspconfig').util.default_config
      lspconfig_defaults.capabilities = vim.tbl_deep_extend('force', lspconfig_defaults.capabilities, lsp_capabilities)

      require('plugins.coding.lsp.keymaps')

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

          if client.name == 'yamlls' then
            -- Need this so that conform uses LSP to format yaml.* files.
            client.server_capabilities.documentFormattingProvider = true
          end
        end,
        desc = 'LSP: Disable hover capability from Ruff',
      })

      vim.lsp.enable({
        'basedpyright',
        'bashls',
        'gopls',
        'harper_ls',
        'jsonls',
        'lua_ls',
        'ruff',
        'taplo',
        'typos_lsp',
        'yamlls',
        -- 'astro',
        -- 'copilot_ls',
        -- 'postgres_lsp',
        -- 'terraformls',
        -- 'tflint',
      })

      vim.lsp.config('basedpyright', {
        settings = {
          basedpyright = {
            disableOrganizeImports = true,
            analysis = {
              diagnosticMode = 'openFilesOnly',
              inlayHints = {
                callArgumentNames = true,
              },
            },
          },
        },
      })

      vim.lsp.config('gopls', {
        -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md#settings
        settings = {
          gopls = {
            gofumpt = true,
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
        },
      })

      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
      vim.lsp.config('lua_ls', {
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
              path ~= vim.fn.stdpath('config')
              and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
            then
              return
            end
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              -- Tell the language server which version of Lua you're using
              -- (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
            },

            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { 'vim' },
            },

            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                -- Depending on the usage, you might want to add additional paths here.
                -- "${3rd}/luv/library"
                -- "${3rd}/busted/library",
              },
              -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
              -- and will cause issues when working on your own configuration
              -- (see https://github.com/neovim/nvim-lspconfig/issues/3189)
              -- library = vim.api.nvim_get_runtime_file("", true)
            },
          })
        end,
        settings = {
          Lua = {
            telemetry = {
              enable = false,
            },
          },
        },
      })

      vim.lsp.config('bashls', {
        filetypes = { 'bash', 'sh' },
        settings = {
          bashIde = {
            globPattern = '*@(.sh|.inc|.bash|.command)',
          },
        },
      })

      vim.lsp.config('harper_ls', {
        filetypes = { 'gitcommit', 'html', 'markdown', 'typescriptreact' },
        settings = {
          ['harper-ls'] = {
            codeActions = {
              forceStable = true,
            },
            linters = {
              spell_check = true,
              spelled_numbers = true,
              an_a = true,
              sentence_capitalization = false,
              unclosed_quotes = true,
              wrong_quotes = false,
              long_sentences = false,
              repeated_words = true,
              spaces = true,
              matcher = true,
              linking_verbs = true,
              boring_words = true,
              capitalize_personal_pronouns = true,
              oxford_comma = true,
              avoid_curses = true,
              merge_words = true,
              plural_conjugate = true,
            },
            -- isolateEnglish = false,
          },
        },
      })

      vim.lsp.config('jsonls', {
        init_options = {
          provideFormatter = false,
          documentRangeFormattingProvider = false,
        },
        on_new_config = function(new_config)
          new_config.settings.json.schemas = new_config.settings.json.schemas or {}
          vim.list_extend(new_config.settings.json.schemas, require('schemastore').json.schemas())
        end,
        settings = {
          json = {
            format = { enable = true },
            validate = { enable = true },
          },
        },
        filetypes = { 'json', 'jsonc', 'json5' },
      })

      vim.lsp.config('yamlls', {
        -- lazy-load schemastore when needed
        on_new_config = function(new_config)
          new_config.settings.yaml.schemas = new_config.settings.yaml.schemas or {}
          vim.list_extend(new_config.settings.yaml.schemas, require('schemastore').yaml.schemas())
        end,
        settings = {
          redhat = { telemetry = { enabled = false } },
          yaml = {
            format = {
              enable = true,
            },
            schemaStore = {
              -- Must disable built-in schemaStore support to use
              -- schemas from SchemaStore.nvim plugin
              enable = false,
              -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
              url = '',
            },
            filetype_exclude = { 'helm' },
          },
        },
        filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab', 'yaml.github' },
      })

      require('plugins.coding.lsp.diagnostics')
    end,
  },
}
