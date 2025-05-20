return {
  strategy = 'chat',
  description = 'Agent mode with explicit set of tools',
  opts = {
    index = 21,
    is_default = false,
    short_name = 'agent',
    is_slash_cmd = true,
    auto_submit = false,
  },
  prompts = {
    {
      role = 'user',
      contains_code = true,
      content = function()
        return ([[
          You are in agent mode:
          Use tools to answer user request using @cmd_runner
          - Do NOT use `grep`
          - Search content and patterns using `fzf`
          - Do NOT use `find`
          - Search files with `fd`

          You are an assistant with access to tools. Follow these strict guidelines:
            1. Call only one tool at a time
            2. Wait for the tool's response before determining your next action
            3. Do not plan multiple tool calls in advance
            4. After each tool call, respond to the user with your observations
            5. Do not group multiple operations into a single tool call
          ]]):gsub('^ +', '', 1):gsub('\n +', '\n')
      end,
    },
  },
}
