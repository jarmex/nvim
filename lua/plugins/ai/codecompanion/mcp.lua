local M = {}
M.mcpServers = {
  servers = {
    ['memory'] = {
      cmd = { 'npx', '-y', '@modelcontextprotocol/server-memory' },
    },
    ['sequential-thinking'] = {
      cmd = { 'npx', '-y', '@modelcontextprotocol/server-sequential-thinking' },
    },
    ['tavily-mcp'] = {
      cmd = { 'npx', '-y', 'tavily-mcp@latest' },
      env = {
        -- TAVILY_API_KEY = 'cmd:op read op://personal/Tavily_API/credential --no-newline',
      },
      tool_defaults = {
        require_approval_before = true,
      },
    },
    ['linear'] = {
      cmd = { 'npx', '-y', 'mcp-remote', 'https://mcp.linear.app/sse' },
      tool_defaults = {
        require_approval_before = false,
      },
      tool_overrides = {
        delete_attachment = { opts = { require_approval_before = true } },
        delete_comment = { opts = { require_approval_before = true } },
        save_issue = { opts = { require_approval_before = true } },
        create_issue_label = { opts = { require_approval_before = true } },
        save_project = { opts = { require_approval_before = true } },
        save_initiative = { opts = { require_approval_before = true } },
        save_status_update = { opts = { require_approval_before = true } },
        delete_status_update = { opts = { require_approval_before = true } },
      },
    },
  },
}
return M
