local icons = require('helpers.icons')

local adaptersList = {
  ['neotest-vitest'] = {},
  -- ['neotest-jest'] = {},
  -- ['neotest-jest'] = {
  --   jestCommand = 'pnpm jest',
  --   -- jestConfigFile = "jest.config.js",
  --   env = { CI = true },
  --   cwd = function(path)
  --     return require('lspconfig.util').root_pattern('package.json', 'jest.config.js')(path)
  --   end,
  -- },
}

return {
  {
    'nvim-neotest/neotest',
    version = '*',
    event = 'VeryLazy',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-neotest/neotest-jest',
      'marilari88/neotest-vitest',
      'nvim-neotest/neotest-plenary',
    },
    keys = require('plugins.coding.neotest.keymaps').keymaps(),
    opts = function()
      return {
        consumers = {
          overseer = require('neotest.consumers.overseer'),
        },
        log_level = vim.log.levels.ERROR,
        status = { enabled = true, virtual_text = true, signs = true },
        output = { enabled = true, open_on_run = false },
        discovery = { enabled = false }, -- recommend by neotest-jest
        diagnostic = { enabled = true },
        floating = {
          border = 'rounded',
          max_height = 0.90,
          max_width = 0.90,
        },
        quickfix = {
          enabled = false,
          -- open = false,
          open = function()
            require('trouble').open({ mode = 'quickfix', focus = false })
          end,
        },
        output_panel = {
          open = 'rightbelow vsplit | resize 40',
        },
        strategies = {
          integrated = {
            width = 180,
          },
        },
        summary = {
          open = 'botright vsplit | vertical resize 60',
          enabled = true,
          expand_errors = true,
          follow = true,
          mappings = {
            attach = 'a',
            expand = { '<Space>', '<2-LeftMouse>' },
            expand_all = '<tab>',
            jumpto = { 'i', '<cr>' },
            mark = 'm',
            next_failed = 'J',
            output = 'o',
            prev_failed = 'K',
            run = 'r',
            debug = 'd',
            run_marked = 'R',
            debug_marked = 'D',
            short = 'O',
            stop = 's',
            target = 't',
            clear_marked = 'M',
            clear_target = 'T',
          },
        },

        icons = {
          passed = icons.testing.Success,
          running = '',
          failed = icons.testing.Failed,
          unknown = '',
          expanded = '',
          child_prefix = '',
          child_indent = '',
          final_child_prefix = '',
          non_collapsible = '',
          collapsed = '',

          running_animated = vim.tbl_map(function(s)
            return s .. ' '
          end, { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }),
        },
        adapters = adaptersList,
      }
    end,
    config = function(_, opts)
      local neotest_ns = vim.api.nvim_create_namespace('neotest')
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
            return message
          end,
        },
      }, neotest_ns)

      if opts.adapters then
        local adapters = {}
        for name, config in pairs(opts.adapters or {}) do
          if type(name) == 'number' then
            if type(config) == 'string' then
              config = require(config)
            end
            adapters[#adapters + 1] = config
          elseif config ~= false then
            local adapter = require(name)
            if type(config) == 'table' and not vim.tbl_isempty(config) then
              local meta = getmetatable(adapter)
              if adapter.setup then
                adapter.setup(config)
              elseif meta and meta.__call then
                adapter(config)
              else
                error('Adapter ' .. name .. ' does not support setup')
              end
            end
            adapters[#adapters + 1] = adapter
          end
        end
        opts.adapters = adapters
      end
      require('neotest').setup(opts)

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'neotest-*',
        callback = function()
          for _, lhs in pairs({ 'q', '<esc>' }) do
            vim.keymap.set('n', lhs, function()
              vim.cmd('quit')
            end, { buffer = 0 })
          end
        end,
      })

      -- Set up the autocommand for NeotestOutput filetype
      -- Scroll to the bottom of the output panel
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'neotest-output-panel',
        group = vim.api.nvim_create_augroup('neotest-scroll', { clear = true }),
        callback = function()
          vim.cmd('norm G')
        end,
      })
    end,
  },
  {
    'nvim-neotest/neotest',
    optional = true,
    dependencies = {
      -- { 'jarmex/neotest-ginkgo' },
      {
        'fredrikaverpil/neotest-golang',
        -- enabled = false,
        version = '*',
        dependencies = {
          'leoluz/nvim-dap-go',
        },
      },
    },
    opts = {
      adapters = {
        -- ['neotest-ginkgo'] = {
        --   -- Here we can set options for neotest-go, e.g.
        --   -- args = { "-tags=integration" }
        --   --   args = { "-count=1", "-timeout=60s", "-race", "-cover" },
        --   experimental = {
        --     test_table = true,
        --   },
        -- },
        ['neotest-golang'] = {
          args = { '-coverprofile=' .. vim.fn.getcwd() .. '/coverage.out' },
          experimental = {
            test_table = true,
          },
        },
      },
    },
  },
}
