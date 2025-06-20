-- https://github.com/lazymaniac/nvim-ide/blob/master/lua/plugins/lsp/lang/java.lua
return {
  {
    'mfussenegger/nvim-jdtls',
    ft = { 'java' },
    config = function()
      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
      local project_hash = string.sub(vim.api.nvim_call_function('sha256', { vim.fn.getcwd() }), 1, 6)
      local data_path = vim.env.HOME .. '/.cache/jdtls/' .. project_name .. '-' .. project_hash

      local jdtls = require('jdtls')

      local on_attach = function(_, bufnr)
        ---@diagnostic disable-next-line: missing-fields
        require('jdtls').setup_dap({ hotcodereplace = 'auto' })
        require('jdtls.dap').setup_dap_main_class_configs()
        require('plugins.coding.lsp.keymaps').keymap(bufnr)

        vim.cmd([[
            command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)
            command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)
            command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()
            command! -buffer JdtJol lua require('jdtls').jol()
            command! -buffer JdtBytecode lua require('jdtls').javap()
            command! -buffer JdtJshell lua require('jdtls').jshell()
        ]])

        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', '<leader><leader>o', jdtls.organize_imports, opts)
        -- keymap.set("n", "<leader>dn", ":lua require('jdtls').test_nearest_method()<CR>", opts)
        -- keymap.set("n", "<leader>dc", ":lua require('jdtls').test_class()<CR>", opts)

        vim.api.nvim_create_user_command('JavaOrganizeImports', jdtls.organize_imports, {})
        vim.api.nvim_create_user_command('JavaTestClass', jdtls.test_class, {})
        vim.api.nvim_create_user_command('JavaTestNearest', jdtls.test_nearest_method, {})
      end

      local config = {
        root_dir = require('lspconfig').util.root_pattern(
          '.git',
          'mvnw',
          'gradlew',
          'pom.xml',
          'build.gradle',
          'build.gradle.kts'
        )(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())),
        on_attach = on_attach,
        cmd = {
          'jdtls',
          '-configuration',
          vim.env.HOME .. '/.cache/jdtls/configuration',
          '-data',
          data_path,
        },
        cmd_env = {
          JAVA_HOME = require('helpers.jvm').home(21),
        },
        init_options = {
          bundles = vim.split(vim.fn.glob(vim.env.MASON .. '/share/java-*/*.jar'), '\n'),
          extendedClientCapabilities = {
            progressReportProvider = false,
            resolveAdditionalTextEditsSupport = true,
          },
        },
        capabilities = require('blink.cmp').get_lsp_capabilities(),
        settings = {
          redhat = {
            telemetry = {
              enabled = false,
            },
          },
          java = {
            import = {
              saveActions = {
                organizeImports = true,
              },
              maven = {
                enabled = true,
              },
              gradle = {
                enabled = true,
              },
            },
            implementationsCodeLens = {
              enabled = true,
            },
            referencesCodeLens = {
              enabled = true,
            },
            signatureHelp = {
              enabled = true,
            },
            configuration = {
              runtimes = {
                {
                  name = 'JavaSE-11',
                  path = require('helpers.jvm').home(11),
                },
                {
                  name = 'JavaSE-17',
                  path = require('helpers.jvm').home(17),
                },
                {
                  name = 'JavaSE-21',
                  path = require('helpers.jvm').home(21),
                },
                {
                  name = 'JavaSE-23',
                  path = require('helpers.jvm').home(23),
                },
              },
            },
            completion = {
              importOrder = { '', 'javax', 'java', '#' },
              matchCase = 'firstLetter',
              maxResults = 100,
              postfix = {
                enabled = true,
              },
              enabled = true,
              chain = {
                enabled = true,
              },
              collapseCompletionItems = true,
              lazyResolveTextEdit = {
                enabled = true,
              },
              favoriteStaticMembers = {
                'org.hamcrest.MatcherAssert.assertThat',
                'org.hamcrest.Matchers.*',
                'org.hamcrest.CoreMatchers.*',
                'org.junit.jupiter.api.Assertions.*',
                'java.util.Objects.requireNonNull',
                'java.util.Objects.requireNonNullElse',
                'org.mockito.Mockito.*',
                'org.mockito.BDDMockito.*',
                'org.instancio.Instancio.*',
                'org.instancio.Select.*',
              },
              filteredTypes = { 'java.awt.*', 'com.sun.*', 'sun.*', 'jdk.*', 'org.graalvm.*', 'io.micrometer.shaded.*' },
              guessMethodArguments = 'auto',
            },
            cleanup = {
              actions = { 'renameFileToType' },
              actionsOnSave = {
                -- "qualifyMembers",
                -- "qualifyStaticMembers",
                'addOverride',
                'addDeprecated',
                'stringConcatToTextBlock',
                'invertEquals',
                -- "addFinalModifier",
                'instanceofPatternMatch',
                'lambdaExpression',
                'switchExpression',
              },
            },
            codeGeneration = {
              insertionLocation = 'afterCursor',
              generateComments = false,
              hashCodeEquals = {
                useInstanceof = true,
                useJava7Objects = true,
              },
              toString = {
                codeStyle = 'STRING_BUILDER_CHAINED', -- "STRING_CONCATENATION" | "STRING_BUILDER" | "STRING_BUILDER_CHAINED" | "STRING_FORMAT"
                limitElements = 0,
                listArrayContents = true,
                skipNullValues = false,
                template = '${object.className} [${member.name()}=${member.value}, ${otherMembers}]',
              },
              useBlocks = true,
            },
            codeAction = {
              sortMembers = {
                avoidVolatileChanges = false,
              },
            },
            refactoring = {
              extract = {
                interface = {
                  replace = true,
                },
              },
            },
            format = {
              comments = {
                enabled = true,
              },
              enabled = true,
              onType = {
                enabled = true,
              },
              settings = {
                url = '~/.config/nvim/java-formatter.xml',
              },
            },
            inlayHints = {
              parameterNames = {
                enabled = 'all', -- literals, all, none
                exclusions = {},
              },
            },
            maven = {
              downloadSources = true,
              updateSnapshots = false,
            },
            maxConcurrentBuilds = 1,
            references = {
              includeAccessors = true,
              includeDecompiledSources = true,
            },
          },
        },
      }

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'java',
        callback = function()
          require('jdtls').start_or_attach(config)
        end,
      })
    end,
  },
}
