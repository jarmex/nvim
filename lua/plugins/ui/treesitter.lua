return {
  {
    --- Treesitter
    'nvim-treesitter/nvim-treesitter',
    -- version = false,
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    event = { 'BufNewFile', 'BufReadPost', 'BufWritePre', 'VeryLazy' },
    cmd = {
      'TSInstall',
      'TSUninstall',
      'TSUpdate',
      'TSUpdateSync',
      'TSInstallInfo',
      'TSInstallSync',
      'TSInstallFromGrammar',
    },
    keys = {
      { '<c-space>', desc = 'Increment selection' },
      { '<bs>', desc = 'Decrement selection', mode = 'x' },
    },
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local filetype = args.match
          local lang = vim.treesitter.language.get_lang(filetype)
          if vim.treesitter.language.add(lang) then
            vim.treesitter.start()
          end
        end,
      })
    end,
    dependencies = { 'windwp/nvim-ts-autotag' },
    opts = function()
      return {
        ignore_install = { 'help' },
        ensure_installed = {
          'awk',
          'bash',
          'c',
          'c_sharp',
          'cpp',
          'css',
          'diff',
          'dockerfile',
          'fennel',
          'graphql',
          'go',
          'gomod',
          'gosum',
          'gowork',
          'html',
          'http',
          'hurl',
          'java',
          'javascript',
          'jsdoc',
          'json',
          'jsonc',
          'json5',
          'ledger',
          'lua',
          'luap', -- lua patterns
          'luadoc', -- lua annotations
          'make',
          'markdown',
          'markdown_inline',
          'ninja',
          'proto',
          'python',
          'query',
          'regex',
          'rst',
          'ron',
          'rust',
          'scss',
          'sql',
          -- 'teal',
          'toml',
          'tsx',
          'typescript',
          'vue',
          'vim',
          'vimdoc',
          'yaml',
          'svelte',
        },

        auto_install = true, -- install missing parsers when entering a buffer
        highlight = {
          enable = vim.g.vscode ~= 1,
          use_languagetree = true,
          -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
          --  If you are experiencing weird indenting issues, add the language to
          --  the list of additional_vim_regex_highlighting and disabled languages for indent.
          additional_vim_regex_highlighting = {
            'python',
            'vim',
          },
        },
        indent = { enable = true },
        -- context_commentstring = { enable = true, enable_autocmd = false },
        autopairs = { enable = true },
        -- playground = { enable = true},
        matchup = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<C-space>',
            node_incremental = '<C-space>',
            scope_incremental = '<nop>',
            node_decremental = '<bs>',
          },
        },
        -- nvim-treesitter-endwise plugin
        endwise = { enable = true },
        -- textobjects = {
        --   enable = false,
        --   move = {
        --     enable = true,
        --     goto_next_start = { [']f'] = '@function.outer', [']c'] = '@class.outer' },
        --     goto_next_end = { [']F'] = '@function.outer', [']C'] = '@class.outer' },
        --     goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer' },
        --     goto_previous_end = { ['[F'] = '@function.outer', ['[C'] = '@class.outer' },
        --   },
        --   select = {
        --     enable = true,
        --     lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        --     keymaps = {
        --       -- Use v[keymap], c[keymap], d[keymap] to perform any operation
        --       ['af'] = '@function.outer',
        --       ['if'] = '@function.inner',
        --       ['ac'] = '@class.outer',
        --     },
        --   },
        -- },
        -- query_linter = {
        --   enable = true,
        --   use_virtual_text = true,
        --   lint_events = { 'BufWrite', 'CursorHold' },
        -- },
      }
    end,
    config = function(_, opts)
      -- if type(opts.ensure_installed) == 'table' then
      --   local added = {}
      --   opts.ensure_installed = vim.tbl_filter(function(parser)
      --     if added[parser] then
      --       return false
      --     end
      --     added[parser] = true
      --     return true
      --   end, opts.ensure_installed)
      -- end
      -- require('nvim-treesitter.configs').setup(opts)
      require('nvim-treesitter').install(opts.ensure_installed)
      require('nvim-treesitter').update()
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    opts = {
      select = {
        enable = true,
        lookahead = true,
        selection_modes = {
          ['@parameter.outer'] = 'v', -- charwise
          ['@function.outer'] = 'V', -- linewise
          ['@class.outer'] = '<c-v>', -- blockwise
        },
      },
      move = {
        enable = true,
        set_jumps = true,
      },

      include_surrounding_whitespace = true,
    },
    keys = vim
      .iter(vim
        .iter({
          select = {
            ['af'] = { query = '@function.outer', desc = 'function outer' },
            ['if'] = { query = '@function.inner', desc = 'function innner' },
            ['ac'] = { query = '@class.outer', desc = 'class outer' },
            ['ic'] = { query = '@class.inner', desc = 'class inner' },

            ['aj'] = { query = '@cell', desc = 'cell outer' },
            ['ij'] = { query = '@cellcontent', desc = 'cell inner' },

            ['as'] = { query = '@local.scope', desc = 'locals' },
          },
          move = {
            goto_next_start = {
              [']f'] = { query = '@function.outer', desc = 'function start' },
              [']c'] = { query = '@class.outer', desc = 'class start' },
              [']z'] = { query = '@fold', query_group = 'folds', desc = 'fold' },
              [']j'] = {
                query = { '@cellseparator.code', '@cellseparator.markdown', '@cellseparator.raw' },
                desc = 'cell separator',
              },
            },
            goto_previous_start = {
              ['[f'] = { query = '@function.outer', desc = 'function start' },
              ['[c'] = { query = '@class.outer', desc = 'class start' },
              ['[z'] = { query = '@fold', query_group = 'folds', desc = 'fold' },
              ['[j'] = {
                query = { '@cellseparator.code', '@cellseparator.markdown', '@cellseparator.raw' },
                desc = 'cell separator',
              },
            },
          },
        })
        :map(function(feat, v)
          if feat == 'select' then
            return vim
              .iter(v)
              :map(function(key, opts)
                return {
                  key,
                  function()
                    require('nvim-treesitter-textobjects.select').select_textobject(opts.query, 'textobjects')
                  end,
                  desc = opts.desc,
                  mode = { 'x', 'o' },
                }
              end)
              :totable()
          end
          if feat == 'move' then
            local bb = vim
              .iter(pairs(v))
              :map(function(func, maps)
                return vim
                  .iter(maps)
                  :map(function(key, opts)
                    return {
                      key,
                      function()
                        require('nvim-treesitter-textobjects.move')[func](opts.query, 'textobjects')
                      end,
                      desc = opts.desc,
                      mode = { 'n', 'x', 'o' },
                    }
                  end)
                  :totable()
              end)
              :totable()
            return vim.iter(bb):flatten():totable()
          end
          return {}
        end)
        :totable())
      :flatten()
      :totable(),
  },
  'JoosepAlviste/nvim-ts-context-commentstring', -- Smart commenting in multi language files - Enabled in Treesitter file
  'windwp/nvim-ts-autotag', -- Autoclose and autorename HTML and Vue tags
  --"rrethy/nvim-treesitter-endwise", -- Automatically add end keywords for Ruby, Lua, Python, and more
  {
    'windwp/nvim-autopairs', -- Autopair plugin
    event = 'InsertEnter',
    opts = {
      check_ts = true,
      enable_moveright = true,
      fast_wrap = {
        map = '<c-e>',
      },
    },
    config = function(_, opts)
      local autopairs = require('nvim-autopairs')

      autopairs.setup(opts)

      local Rule = require('nvim-autopairs.rule')
      local ts_conds = require('nvim-autopairs.ts-conds')

      autopairs.add_rules({
        Rule('{{', '  }', 'vue'):set_end_pair_length(2):with_pair(ts_conds.is_ts_node('text')),
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'BufReadPre',
    enabled = true,
    opts = { mode = 'cursor', max_lines = 3 },
  },
  -- {
  --   'AbaoFromCUG/nvim-treesitter-endwise', -- Automatically add end keywords for Ruby, Lua, Python, and more
  --   branch = 'fix/iter-matches',
  -- },
  {
    'abecodes/tabout.nvim', -- Tab out from parenthesis, quotes, brackets...
    opts = {
      tabkey = '<Tab>', -- key to trigger tabout, set to an empty string to disable
      backwards_tabkey = '<S-Tab>', -- key to trigger backwards tabout, set to an empty string to disable
      completion = true, -- We use tab for completion so set this to true
    },
  },
}
