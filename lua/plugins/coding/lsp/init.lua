return {
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

      require('plugins.coding.lsp.keymaps')

      -- Auto goimports with gopls
      -- https://github.com/neovim/nvim-lspconfig/issues/115#issuecomment-1128115341
      -- https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-imports
      --[[
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
      ]]

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
        'cssls',
        -- 'tsserver',
        -- 'tailwindcss',
        -- 'svelte',
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

      vim.lsp.config('copilot', {
        settings = {
          telemetry = {
            -- doesn't work, seems to be a vscode setting
            telemetryLevel = 'off',
          },
        },
      })

      vim.lsp.config('gopls', {
        -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md#settings
        settings = {
          env = {
            GOEXPERIMENT = 'rangefunc',
          },
          gopls = {
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
              ST1000 = false,
              -- Variable naming convention check
              ST1003 = true,
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
              disable = { 'missing-fields' },
            },

            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME, -- The base directory (fast)
                vim.fn.stdpath('config'), -- Your config dir (fast)
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
        settings = {
          json = {
            validate = { enable = true },
            schemas = require('schemastore').json.schemas(),
          },
        },
        filetypes = { 'json', 'jsonc', 'json5' },
      })

      vim.lsp.config('helm_ls', {
        yamlls = {
          path = 'yaml-language-server',
        },
      })

      vim.lsp.enable({ 'helm_ls' })

      vim.lsp.config('yamlls', {
        settings = {
          redhat = { telemetry = { enabled = false } },
          yaml = {
            schemaStore = {
              -- Must disable built-in schemaStore support to use
              -- schemas from SchemaStore.nvim plugin
              enable = false,
              -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
              url = '',
            },
            schemas = require('schemastore').yaml.schemas(),
            filetype_exclude = { 'helm' },
          },
        },
        filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab', 'yaml.github' },
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

      -- Prevent LSP from attaching to virtual buffers such as diffview.
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local bufname = vim.api.nvim_buf_get_name(args.buf)
          if bufname:match('^diffview://') then
            vim.schedule(function()
              vim.lsp.buf_detach_client(args.buf, args.data.client_id)
            end)
          end
        end,
      })
    end,
  },
}
