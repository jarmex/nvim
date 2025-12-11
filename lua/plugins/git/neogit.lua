return {
  {
    'NeogitOrg/neogit',
    version = '*',
    event = 'VeryLazy',
    dependencies = {
      'sindrets/diffview.nvim', -- optional - Diff integration
      'nvim-lua/plenary.nvim',
      'folke/snacks.nvim',
    },
    cmd = 'Neogit',
    opts = {
      kind = 'tab',
      commit_view = {
        kind = 'split',
        verify_commit = vim.fn.executable('gpg') == 1,
      },
      auto_show_console = true,
      auto_close_console = true,
      console_timeout = 2000,
      disable_context_highlighting = false,
      disable_signs = false,
      disable_hint = false,
      commit_select_view = { kind = 'tab' },
      log_view = { kind = 'tab' },
      reflog_view = { kind = 'tab' },
      rebase_editor = { kind = 'auto' },
      filewatcher = { interval = 2000, enabled = true },
      disable_insert_on_commit = true,
      fetch_after_checkout = false,
      graph_style = 'unicode',
      process_spinner = true,
      commit_editor = {
        kind = 'tab',
        show_staged_diff = true,
        staged_diff_split_kind = 'split',
        spell_check = true,
      },
      remember_settings = true,
      use_per_project_settings = true,
      integrations = {
        snacks = true,
        diffview = true,
        telescope = false,
      },
      status = {
        show_head_commit_hash = true,
        recent_commit_count = 10,
        HEAD_padding = 10,
        HEAD_folded = false,
        mode_padding = 3,
        mode_text = {
          M = 'modified',
          N = 'new file',
          A = 'added',
          D = 'deleted',
          C = 'copied',
          U = 'updated',
          R = 'renamed',
          DD = 'unmerged',
          AU = 'unmerged',
          UD = 'unmerged',
          UA = 'unmerged',
          DU = 'unmerged',
          AA = 'unmerged',
          UU = 'unmerged',
          ['?'] = 'untracked',
        },
      },
      sort_branches = '-committerdate',

      commit_order = 'topo',

      disable_line_numbers = true,
      disable_relative_line_numbers = true,

      sections = {
        stashes = {
          folded = true,
          hidden = false,
        },
        unpulled_upstream = {
          folded = true,
          hidden = false,
        },
        recent = {
          folded = true,
          hidden = false,
        },
        rebase = {
          folded = false,
          hidden = false,
        },
      },
    },
    keys = {
      { '<leader>gn', '<cmd>Neogit<cr>', desc = 'Neogit' },
    },
    config = true,
  },
}
