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
      -- Keymap to open history from chat buffer (default: gh)
      keymap = 'gh',
      save_chat_keymap = 'sc',
      -- Automatically generate titles for new chats
      auto_generate_title = true,
      ---On exiting and entering neovim, loads the last chat on opening chat
      continue_last_chat = false,
      ---When chat is cleared with `gx` delete the chat from history
      delete_on_clearing_chat = false,
      -- Picker interface ("telescope", "snacks" or "default")
      picker = 'snacks',
      ---Enable detailed logging for history extension
      enable_logging = false,
      ---Directory path to save the chats
      dir_to_save = vim.fn.stdpath('data') .. '/codecompanion-history',
      auto_save = false,
      -- expiration_days = 30,
      -- save_chat_keymap = '<localleader>hs',
      title_generation_opts = {
        ---Adapter for generating titles (defaults to current chat adapter)
        adapter = 'openai', -- "copilot"
        ---Model for generating titles (defaults to current chat model)
        model = 'gpt-4.1', -- "gpt-4o"
      },
    },
  },
  vectorcode = {
    opts = {
      add_tool = true,
      add_slash_command = true,
      ---@type VectorCode.CodeCompanion.ToolOpts
      tool_opts = {
        use_lsp = true,
        ls_on_start = false,
        no_duplicate = true,
        chunk_mode = true,
      },
    },
  },
  gitcommit = {
    callback = 'codecompanion._extensions.gitcommit',
    opts = {
      adapter = 'openai', -- Optional: specify LLM adapter (defaults to codecompanion chat adapter)
      model = 'gpt-4.1-mini', -- default model for gitcommit
      add_slash_command = true, -- Optional: adds /gitcommit slash command
      exclude_files = {
        '*.pb.go',
        '*.min.js',
        '*.lock',
        '*gen.go',
        'vendor/*',
        '*.generated.*',
      }, -- Optional: exclude files from diff analysis
      add_git_tool = true, -- Optional: add @git_read and @git_edit tools to CodeCompanion (default: true)
      add_git_commands = true, -- Optional: add :CodeCompanionGit commands (default: true)
      gitcommit_select_count = 100, -- Optional: number of recent commits for /gitcommit slash command (default: 100)
      buffer = {
        enabled = true, -- Enable gitcommit buffer keymaps
        keymap = '<leader>gc', -- Keymap for generating commit message in gitcommit buffer
        auto_generate = false, -- Automatically generate message on entering gitcommit buffer
        auto_generate_delay = 100, -- Delay in ms before auto-generating
      },
    },
  },
}
