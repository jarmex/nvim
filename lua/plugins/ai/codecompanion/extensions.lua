return {
  mcphub = {
    callback = 'mcphub.extensions.codecompanion',
    opts = {
      make_vars = true,
      make_slash_commands = true,
      show_result_in_chat = true,
    },
  },
  history = {
    enabled = true,
    opts = {
      keymap = 'gh',
      save_chat_keymap = 'sc',
      auto_generate_title = true,
      continue_last_chat = false,
      delete_on_clearing_chat = true,
      picker = 'snacks',
      enable_logging = false,
      dir_to_save = vim.fn.stdpath('data') .. '/codecompanion-history',
      auto_save = false,
      -- expiration_days = 30,
      -- save_chat_keymap = '<localleader>hs',
    },
  },
  vectorcode = {
    opts = {
      add_tool = true,
    },
  },
  gitcommit = {
    callback = 'codecompanion._extensions.gitcommit',
    opts = {
      add_slash_command = true, -- Optional: adds /gitcommit slash command
      adapter = 'openai', -- Optional: specify LLM adapter (defaults to codecompanion chat adapter)
      -- model = 'gpt-4', -- Optional: specify model (defaults to codecompanion chat model)
      languages = { 'English' }, -- Optional: list of languages for commit messages
      exclude_files = {
        '*.pb.go',
        '*.min.js',
        '*.lock',
        '*gen.go',
        'vendor/*',
        '*.generated.*',
      }, -- Optional: exclude files from diff analysis
      buffer = {
        enabled = true, -- Enable gitcommit buffer keymaps
        keymap = '<leader>gc', -- Keymap for generating commit message in gitcommit buffer
      },
    },
  },
}
