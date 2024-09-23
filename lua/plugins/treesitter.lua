return {
  {
    'windwp/nvim-autopairs', -- Autopair plugin
    opts = {
      close_triple_quotes = true,
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
  -- comments
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'BufReadPre',
    enabled = true,
    opts = { mode = 'cursor', max_lines = 3 },
  },
  {
    'PriceHiller/nvim-treesitter-endwise', -- Automatically add end keywords for Ruby, Lua, Python, and more
    branch = 'fix/iter-matches',
  },
  {
    'abecodes/tabout.nvim', -- Tab out from parenthesis, quotes, brackets...
    opts = {
      tabkey = '<Tab>', -- key to trigger tabout, set to an empty string to disable
      backwards_tabkey = '<S-Tab>', -- key to trigger backwards tabout, set to an empty string to disable
      completion = true, -- We use tab for completion so set this to true
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    event = 'VeryLazy',
    config = function()
      -- When in diff mode, we want to use the default
      -- vim text objects c & C instead of the treesitter ones.
      local move = require('nvim-treesitter.textobjects.move') ---@type table<string,fun(...)>
      local configs = require('nvim-treesitter.configs')
      for name, fn in pairs(move) do
        if name:find('goto') == 1 then
          move[name] = function(q, ...)
            if vim.wo.diff then
              local config = configs.get_module('textobjects.move')[name] ---@type table<string,string>
              for key, query in pairs(config or {}) do
                if q == query and key:find('[%]%[][cC]') then
                  vim.cmd('normal! ' .. key)
                  return
                end
              end
            end
            return fn(q, ...)
          end
        end
      end
    end,
  },
  {
    --- Treesitter
    'nvim-treesitter/nvim-treesitter',
    version = false,
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
    init = function(plugin)
      -- CODE FROM LazyVim (thanks folke!) https://github.com/LazyVim/LazyVim/commit/1e1b68d633d4bd4faa912ba5f49ab6b8601dc0c9
      require('lazy.core.loader').add_to_rtp(plugin)
      require('nvim-treesitter.query_predicates')
    end,
    dependencies = {
      'windwp/nvim-ts-autotag',
    },
    opts = function()
      local function is_disable(_, bufnr)
        return bufnr and vim.api.nvim_buf_line_count(bufnr) > 5000
      end
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
          'teal',
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
        highlight = { enable = true, additional_vim_regex_highlighting = false },
        indent = { enable = true, disable = is_disable },
        -- context_commentstring = { enable = true, enable_autocmd = false, disable = is_disable },
        autopairs = { enable = true, disable = is_disable },
        playground = { enable = true, disable = is_disable },
        matchup = { enable = true, disable = is_disable },
        incremental_selection = {
          enable = true,
          disable = is_disable,
          keymaps = {
            init_selection = '<C-space>',
            node_incremental = '<C-space>',
            scope_incremental = '<nop>',
            node_decremental = '<bs>',
          },
        },
        -- nvim-treesitter-endwise plugin
        endwise = { enable = true, disable = is_disable },

        textobjects = {
          move = {
            enable = true,
            goto_next_start = { [']f'] = '@function.outer', [']c'] = '@class.outer' },
            goto_next_end = { [']F'] = '@function.outer', [']C'] = '@class.outer' },
            goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer' },
            goto_previous_end = { ['[F'] = '@function.outer', ['[C'] = '@class.outer' },
          },
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim

            keymaps = {
              -- Use v[keymap], c[keymap], d[keymap] to perform any operation
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
            },
          },
        },
        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = { 'BufWrite', 'CursorHold' },
        },
      }
    end,
    config = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        local added = {}
        opts.ensure_installed = vim.tbl_filter(function(parser)
          if added[parser] then
            return false
          end
          added[parser] = true
          return true
        end, opts.ensure_installed)
      end
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
}
