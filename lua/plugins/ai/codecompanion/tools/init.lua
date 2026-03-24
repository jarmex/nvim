return {
  ['insert_edit_into_file'] = {
    opts = {
      requires_approval_before = {
        buffer = false,
        file = false,
      },
      requires_approval_after = true,
    },
  },
  ['run_command'] = {
    opts = {
      require_approval_before = false,
      requires_approval_after = false,
    },
  },
  ['delete_file'] = {
    opts = {
      requires_approval_before = true,
    },
  },
  read_file = {
    opts = {
      require_approval_before = false,
    },
  },
  grep_search = {
    opts = {
      require_approval_before = false,
    },
  },
  list_files = {
    opts = {
      require_approval_before = false,
    },
  },
  fetch = {
    opts = {
      require_approval_before = false,
    },
  },
  ['memory'] = {
    opts = {
      whitelist = {
        { path = '~/.config/personal/PERSONAL.md', as = '/personal' },
      },
    },
  },
  groups = {
    ['myagent'] = {
      description = 'agent mode with mcp support, automatically run tools',
      prompt = "I'm giving you access to the ${tools} to help you perform coding tasks",
      tools = {
        'run_command',
        'create_file',
        'delete_file',
        'fetch_webpage',
        'files',
        'file_search',
        'agent',
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
    ['my_agent'] = {
      description = 'My custom agent',
      system_prompt = function(group, ctx)
        return string.format('You are a coding agent. The date is %s. The user is on %s.', ctx.date, ctx.os)
      end,
      tools = { 'read_file', 'insert_edit_into_file', 'run_command' },
      opts = {
        collapse_tools = true,
        ignore_system_prompt = true, -- Remove the chat's default system prompt
        ignore_tool_system_prompt = true, -- Remove the default tool system prompt
      },
    },
  },

  opts = {
    auto_submit_success = true, -- Send any successful output to the LLM automatically
    -- wait_timeout = 300000,
    -- default_tools = { 'run_command' },
    --- This is needed when using CodeCompanion's internal tools
    --- (e.g., when @{run_command} runs tests and they fail),
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
