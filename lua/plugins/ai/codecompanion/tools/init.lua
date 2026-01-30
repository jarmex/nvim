return {
  -- ['code_crawler'] = require('plugins.ai.codecompanion.tools.code_crawler'),
  -- ['code_edit'] = require('plugins.ai.codecompanion.tools.code_edit'),
  -- ['tavily'] = require('plugins.ai.codecompanion.tools.tavily'),
  -- ['code_developer'] = require('plugins.ai.codecompanion.tools.developer'),
  groups = {
    ['agent'] = {
      description = 'agent mode with mcp support, automatically run tools',
      prompt = "I'm giving you access to the ${tools} to help you perform coding tasks",
      tools = {
        'cmd_runner',
        'create_file',
        'delete_file',
        'fetch_webpage',
        'files',
        'file_search',
        'full_stack_dev',
        'get_changed_files',
        'grep_search',
        'insert_edit_into_file',
        'list_code_usages',
        'mcp',
        'memory',
        'next_edit_suggestion',
        'read_file',
        'web_search',
      },
      opts = {
        collapse_tools = true,
      },
    },
  },

  opts = {
    auto_submit_success = true, -- Send any successful output to the LLM automatically
    -- wait_timeout = 300000,
    -- default_tools = { 'cmd_runner' },
    --- This is needed when using CodeCompanion's internal tools
    --- (e.g., when @cmd_runner runs tests and they fail),
    --- but with external tools (e.g., @mcp) this might cause issues
    --- because external tools do not return errors in such cases
    --- but may return errors in case of real internal errors
    --- that should be handled by a human, not an LLM.
    auto_submit_errors = true, -- Send any errors to the LLM automatically
    -- system_prompt = {
    -- enabled = true, -- Enable the tools system prompt?
    -- replace_main_system_prompt = false, -- Replace the main system prompt with the tools system prompt?
    -- },
  },
  plan = {
    callback = require('plugins.ai.codecompanion.tools.plan'),
    description = 'Manage an internal todo list',
  },
}
