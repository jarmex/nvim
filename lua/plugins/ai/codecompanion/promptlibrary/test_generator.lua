return {
  ['Write tests for this file'] = {
    interaction = 'chat',
    description = 'Write tests for this file or module following existing convention.',
    opts = {
      auto_submit = true,
      -- ignore_system_prompt = true,
      is_slash_cmd = true,
      alias = 'write-tests',
      adapter = {
        name = 'copilot',
        model = 'claude-haiku-4.5',
      },
    },
    prompts = {
      {
        role = 'user',
        content = [[
#{buffer}
@{full_stack_dev}

Write tests for this file or module.

Follow these additional rules:
- Check for existing tests under common paths, such as `test/`, `spec/`, or `src/**/*.test.*`.
- Follow conventions stablished by existing tests, if any.
- Write minimal tests, covering only the most common logic paths.
- Use mocks for external libraries.
- Do not install any new packages.
- Do not try to run the tests.
        ]],
      },
    },
  },
}
