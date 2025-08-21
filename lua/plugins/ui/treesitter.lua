--- Register parsers from opts.ensure_installed
local function register(ensure_installed)
  for filetype, parser in pairs(ensure_installed) do
    local filetypes = vim.treesitter.language.get_filetypes(parser)
    if not vim.tbl_contains(filetypes, filetype) then
      table.insert(filetypes, filetype)
    end

    -- register and start parsers for filetypes
    vim.treesitter.language.register(parser, filetypes)
  end
end

--- Install and start parsers for nvim-treesitter.
local function install_and_start()
  -- Auto-install and start treesitter parser for any buffer with a registered filetype
  vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
    callback = function(event)
      local bufnr = event.buf
      local filetype = vim.api.nvim_get_option_value('filetype', { buf = bufnr })

      -- Skip if no filetype
      if filetype == '' then
        return
      end

      -- Get parser name based on filetype
      local parser_name = vim.treesitter.language.get_lang(filetype) -- might return filetype (not helpful)
      if not parser_name then
        return
      end
      -- Try to get existing parser (helpful check if filetype was returned above)
      local parser_configs = require('nvim-treesitter.parsers')
      if not parser_configs[parser_name] then
        return -- Parser not available, skip silently
      end

      local parser_installed = pcall(vim.treesitter.get_parser, bufnr, parser_name)

      if not parser_installed then
        -- If not installed, install parser synchronously
        require('nvim-treesitter').install({ parser_name }):wait(30000)
      end

      -- let's check again
      parser_installed = pcall(vim.treesitter.get_parser, bufnr, parser_name)

      if parser_installed then
        -- Start treesitter for this buffer
        vim.treesitter.start(bufnr, parser_name)
      end
    end,
  })
end
return {
  {
    --- Treesitter
    'nvim-treesitter/nvim-treesitter',
    -- version = false,
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    event = { 'BufRead', 'BufNewFile', 'BufReadPost', 'BufWritePre', 'VeryLazy' },
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
      }
    end,
    config = function(_, opts)
      -- require('nvim-treesitter').update()
      -- Register parsers from opts.ensure_installed
      register(opts.ensure_installed)
      -- Create autocmd which installs and starts parsers.
      install_and_start()
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
  -- Tags
  -- Autoclose and autorename HTML and Vue tags
  { 'windwp/nvim-ts-autotag', event = 'InsertEnter', config = true },

  {
    'windwp/nvim-autopairs', -- Autopair plugin
    event = 'InsertEnter',
    opts = {
      check_ts = true,
      enable_moveright = true,
      disable_filetype = { 'TelescopePrompt', 'spectre_panel', 'snacks_picker_input', 'codecompanion' },
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
    opts = { mode = 'cursor', max_lines = 3, multiwindow = true },
  },
  {
    'abecodes/tabout.nvim', -- Tab out from parenthesis, quotes, brackets...
    opts = {
      tabkey = '<Tab>', -- key to trigger tabout, set to an empty string to disable
      backwards_tabkey = '<S-Tab>', -- key to trigger backwards tabout, set to an empty string to disable
      completion = true, -- We use tab for completion so set this to true
    },
  },
}
