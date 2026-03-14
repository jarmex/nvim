---
name: Write tests for this file
description: Write tests for this file or module following existing convention.
interaction: chat
rules:
  - claude
opts:
  auto_submit: true
  is_slash_cmd: true
  alias: write-tests
  adapter:
    name: copilot
    model: claude-haiku-4.5
---

## user

#{buffer}

@{agent}

Write tests for this file or module.

Follow these additional rules:

- Check for existing tests under common paths, such as `__tests__/`, `spec/`, or `src/**/*.test.*`.
- Follow conventions established by existing tests, if any.
- Write minimal tests, covering only the most common logic paths.
- Use mocks for external libraries.
- Do not install any new packages.
- Do not try to run the tests.
