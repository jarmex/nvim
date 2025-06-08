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
}
