return {
  -- ['code_crawler'] = require('plugins.ai.codecompanion.tools.code_crawler'),
  -- ['code_edit'] = require('plugins.ai.codecompanion.tools.code_edit'),
  -- ['tavily'] = require('plugins.ai.codecompanion.tools.tavily'),
  -- ['code_developer'] = require('plugins.ai.codecompanion.tools.developer'),
  groups = {
    ['agent'] = {
      description = 'Agent tools',
      tools = {
        --- Web search and browsing tools.
        'search_web',
        'fetch_webpage',
        'context7__get-library-docs',
        'context7__resolve-library-id',
        'tavily-mcp__tavily-crawl',
        'tavily-mcp__tavily-extract',
        'tavily-mcp__tavily-map',
        'tavily-mcp__tavily-search',
        --- File analysis tools.
        'list_code_usages',
        'filesystem__get_file_info',
        'filesystem__list_allowed_directories',
        'filesystem__list_directory',
        'filesystem__list_directory_with_sizes',
        'filesystem__read_file',
        'filesystem__read_multiple_files',
        'filesystem__search_files',
        --- File modification tools.
        'filesystem__create_directory',
        'filesystem__edit_file',
        'filesystem__move_file',
        'filesystem__write_file',
        --- Shell tools.
        'shell__shell_exec',
        --- Git tools.
        'git__git_branch',
        'git__git_diff',
        'git__git_diff_staged',
        'git__git_diff_unstaged',
        'git__git_init',
        'git__git_log',
        'git__git_show',
        'git__git_status',
      },
      opts = {
        collapse_tools = true,
      },
    },
    ['agent_old'] = {
      description = 'agent mode with mcp support, automatically run tools',
      tools = {
        'cmd_runner',
        'create_file',
        'file_search',
        'grep_search',
        'insert_edit_into_file',
        'read_file',
        'web_search',
        'list_code_usages',
        'mcp',
      },
      opts = {
        collapse_tools = true,
      },
    },
  },

  opts = {
    auto_submit_success = true, -- Send any successful output to the LLM automatically
    wait_timeout = 300000,
    -- default_tools = { 'cmd_runner', 'files' },
    --- This is needed when using CodeCompanion's internal tools
    --- (e.g., when @cmd_runner runs tests and they fail),
    --- but with external tools (e.g., @mcp) this might cause issues
    --- because external tools do not return errors in such cases
    --- but may return errors in case of real internal errors
    --- that should be handled by a human, not an LLM.
    auto_submit_errors = true, -- Send any errors to the LLM automatically
    system_prompt = {
      enabled = true, -- Enable the tools system prompt?
      replace_main_system_prompt = true, -- Replace the main system prompt with the tools system prompt?
    },
  },
  plan = {
    callback = require('plugins.ai.codecompanion.tools.plan'),
    description = 'Manage an internal todo list',
  },
}
