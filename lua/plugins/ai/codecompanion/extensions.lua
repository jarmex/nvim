local DEFAULT_COPILOT_MODEL = 'gpt-4.1' -- grok-code-fast-1, gpt-4.1
local DEFAULT_ADAPTOR = 'copilot'

return {
  mcphub = {
    callback = 'mcphub.extensions.codecompanion',
    opts = {
      make_tools = true, -- Make individual tools (@server__tool) and server groups (@server) from MCP servers.
      show_server_tools_in_chat = true, -- Show individual tools in chat completion (when make_tools=true).
      add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`).
      make_vars = false, -- Convert resources to #variables. -- TODO: re-enable after ravitemer/mcphub.nvim#279 lands
      show_result_in_chat = true, -- Show mcp tool results in chat.
      make_slash_commands = true, -- Add prompts as /slash commands.
    },
  },
  history = {
    enabled = true,
    auto_save = true,
    expiration_days = 45,
    opts = {
      -- Keymap to open history from chat buffer (default: gh)
      keymap = 'gh',
      -- Automatically generate titles for new chats
      auto_generate_title = false,
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
      expiration_days = 45,
      save_chat_keymap = 'sc',
      title_generation_opts = {
        adapter = nil, -- defaults to current chat adapter when nil
        model = nil, -- defaults to current chat model when nil
        refresh_every_n_prompts = 1, -- 10,
        format_title = function(original_title)
          return original_title
        end,
      },
      picker_keymaps = {
        rename = { n = 'gr', i = '<C-r>' },
        delete = { n = 'dd', i = '<C-d>' },
        duplicate = { n = 'yyp', i = '<C-y>' },
      },
      chat_filter = function(chat_data) -- only chats for the cwd
        return chat_data.cwd == vim.fn.getcwd()
      end,
      summary = {
        create_summary_keymap = 'gcs',
        browse_summaries_keymap = 'gbs',

        generation_opts = {
          adapter = nil, -- defaults to current chat adapter
          model = nil, -- defaults to current chat model
          context_size = 128000, -- max tokens that the model supports
          include_references = true, -- include slash command content
          include_tool_outputs = true, -- include tool execution results
          system_prompt = nil, -- custom system prompt (string or function)
          format_summary = nil, -- custom function to format generated summary e.g to remove <think/> tags from summary
        },
      },
    },
  },
  gitcommit = {
    callback = 'codecompanion._extensions.gitcommit',
    opts = {
      adapter = DEFAULT_ADAPTOR, -- Optional: specify LLM adapter (defaults to codecompanion chat adapter)
      model = DEFAULT_COPILOT_MODEL, -- default model for gitcommit
      languages = { 'English' }, -- Optional: specify languages for diff analysis
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
      buffer = {
        enabled = true, -- Enable gitcommit buffer keymaps
        keymap = '<leader>gc', -- Keymap for generating commit message in gitcommit buffer
        auto_generate = false, -- Automatically generate message on entering gitcommit buffer
      },
      -- Feature toggles
      add_slash_command = true, -- Add /gitcommit slash command
      add_git_tool = true, -- Add @git_read and @git_edit tools
      enable_git_read = true, -- Enable read-only Git operations
      enable_git_edit = true, -- Enable write-access Git operations
      enable_git_bot = true, -- Enable @git_bot tool group (requires both read/write enabled)
      add_git_commands = true, -- Add :CodeCompanionGitCommit commands
      git_tool_auto_submit_errors = false, -- Auto-submit errors to LLM
      git_tool_auto_submit_success = true, -- Auto-submit success to LLM
      gitcommit_select_count = 100, -- Number of commits shown in /gitcommit
      use_commit_history = true, -- Enable commit history context
      commit_history_count = 10, -- Number of recent commits for context
      include_issue_id_from_branch = true, -- Enable automatic issue ID extraction
      issue_id_patterns = { -- Patterns for extracting issue IDs
        { pattern = '^bcd%-(%d%d%d%d)', prefix = 'BCD', format = 'BCD-%s' },
        { pattern = 'MOB%-(%d+)', prefix = 'MOB', format = 'MOB-%s' },
        { pattern = 'TEC%-(%d+)', prefix = 'TEC', format = 'TEC-%s' },
        { pattern = 'ENG%-(%d+)', prefix = 'ENG', format = 'ENG-%s' },
        { pattern = 'INF%-(%d+)', prefix = 'INF', format = 'INF-%s' },
      },
    },
  },
  agentskills = {
    opts = {
      paths = {
        { '~/.config/skills/.claude/skills', recursive = true },
        { '~/.config/skills', recursive = true }, -- Recursive search
      },
    },
  },
  spinner = {
    opts = {
      log_level = 'info',
      -- Available options: "cursor-relative", "snacks", "fidget", "lualine", "heirline", "native", "none"
      style = 'snacks',
    },
  },
  vectorcode = {
    opts = {
      tool_group = {
        -- this will register a tool group called `@vectorcode_toolbox` that contains all 3 tools
        enabled = false,
        -- a list of extra tools that you want to include in `@vectorcode_toolbox`.
        -- if you use @vectorcode_vectorise, it'll be very handy to include
        -- `file_search` here.
        extras = {},
        collapse = false, -- whether the individual tools should be shown in the chat
      },
      tool_opts = {
        ['*'] = {},
        ls = {},
        vectorise = {},
        query = {
          max_num = { chunk = 80, document = 20 },
          default_num = { chunk = 50, document = 10 },
          include_stderr = false,
          use_lsp = true,
          no_duplicate = true,
          chunk_mode = true,
          summarise = {
            enabled = false,
            adapter = nil,
            query_augmented = true,
          },
        },
        files_ls = {},
        files_rm = {},
      },
    },
  },
}
