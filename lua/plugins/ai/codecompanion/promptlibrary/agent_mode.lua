return {
  interaction = 'chat',
  description = 'Already give the current buffer and the agent tools to the chat window',
  opts = {
    index = 21,
    is_default = false,
    is_slash_cmd = true,
    auto_submit = false,
    alias = 'agent_mode_current_buffer',
  },
  prompts = {
    {
      role = 'user',
      contains_code = true,
      content = [[You are a @{full_stack_dev} with access to #{buffer}.

      The current project structure is #{ls} and you can reference project rules via #{rules}.


      ]],
    },
  },
}
