return {
  mcphub = {
    callback = 'mcphub.extensions.codecompanion',
    opts = {
      make_tools = true, -- Make individual tools (@server__tool) and server groups (@server) from MCP servers.
      show_server_tools_in_chat = false, -- Show individual tools in chat completion (when make_tools=true).
      add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`).
      show_result_in_chat = false, -- Show mcp tool results in chat.
      make_vars = true, -- Convert resources to #variables.
      make_slash_commands = true, -- Add prompts as /slash commands.
    },
  },
  history = {
    enabled = true,
    opts = {
      -- Keymap to open history from chat buffer (default: gh)
      keymap = 'gh',
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
      auto_save = true,
      -- Number of days after which chats are automatically deleted (0 to disable)
      expiration_days = 30,
      save_chat_keymap = '<localleader>hs',
      title_generation_opts = {
        ---Adapter for generating titles (defaults to current chat adapter)
        adapter = 'openai', -- "copilot"
        ---Model for generating titles (defaults to current chat model)
        model = 'gpt-4.1', -- "gpt-4o"
      },
      chat_filter = function(chat_data) -- only chats for the cwd
        return chat_data.cwd == vim.fn.getcwd()
      end,
      summary = {
        create_summary_keymap = '<Leader>csc',
        browse_summaries_keymap = '<Leader>csb',
      },
    },
  },
  vectorcode = {
    opts = {
      add_tool = true,
      add_slash_command = true,
      tool_group = {
        -- this will register a tool group called `@vectorcode_toolbox` that contains all 3 tools
        enabled = true,
        -- a list of extra tools that you want to include in `@vectorcode_toolbox`.
        -- if you use @vectorcode_vectorise, it'll be very handy to include
        -- `file_search` here.
        extras = {},
        collapse = true, -- whether the individual tools should be shown in the chat
      },
      ---@type VectorCode.CodeCompanion.ToolOpts
      tool_opts = {
        ---@type VectorCode.CodeCompanion.LsToolOpts
        ls = {},
        ---@type VectorCode.CodeCompanion.VectoriseToolOpts
        vectorise = {},
        ---@type VectorCode.CodeCompanion.QueryToolOpts
        query = {
          max_num = { chunk = -1, document = -1 },
          default_num = { chunk = 50, document = 10 },
          include_stderr = false,
          use_lsp = true,
          no_duplicate = true,
          chunk_mode = true,
        },
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
      languages = {},
      exclude_files = {
        '*.generated.*',
        '*.lock',
        '*.log',
        '*.min.css',
        '*.min.js',
        '*.pb.go',
        '*gen.go',
        '.next/*',
        'build/*',
        'dist/*',
        'node_modules/*',
        'package-lock.json',
        'pnpm-lock.yaml',
        'vendor/*',
        'vendor/*',
        'yarn.lock',
      }, -- Optional: exclude files from diff analysis
      gitcommit_select_count = 100, -- Optional: number of recent commits for /gitcommit slash command (default: 100)
      buffer = {
        enabled = true, -- Enable gitcommit buffer keymaps
        keymap = '<leader>gc', -- Keymap for generating commit message in gitcommit buffer
        auto_generate = false, -- Automatically generate message on entering gitcommit buffer
      },
      add_slash_command = true, -- Add /gitcommit slash command
      add_git_tool = true, -- Add @git_read and @git_edit tools
      enable_git_read = true, -- Enable read-only Git operations
      enable_git_edit = true, -- Enable write-access Git operations
      enable_git_bot = true, -- Enable @git_bot tool group (requires both read/write enabled)
      add_git_commands = true, -- Add :CodeCompanionGitCommit commands
    },
  },
  spinner = {
    opts = {
      -- log_level = "debug",
    },
  },
}
