---
name: Write tests for this file
description: Write tests for this file or module following existing convention.
interaction: chat
rules:
  - claude
tools:
 - activate_skill
 - agent
 - agent_skills
opts:
  auto_submit: true
  is_slash_cmd: true
  alias: write-tests
  adapter:
    name: copilot
    model: claude-sonnet-4.6
---

## user

Generate comprehensive unit tests for the provided code.

Follow these additional rules:

- Check for existing tests under common paths such as `__tests__/`, `spec/`, `src/**/*.spec.*` or `src/**/*.test.*`.
- Follow established conventions from existing tests (naming, structure, utilities, assertion style).
- Write exhaustive tests covering:
    - All public functions, methods, and exported utilities
    - Common logic paths and edge cases (null/undefined inputs, empty collections, boundary values, error conditions)
    - Both success and failure scenarios for async operations
- Prefer mocking for:
    - External libraries and third-party dependencies
    - Network requests, file system operations, and database calls
    - Environment-specific APIs (timers, `Math.random`, `Date.now`, etc.)
    - Complex internal dependencies that would make tests slow or non-deterministic
- Do not install any new packages. Use only the existing testing framework and utilities already present in the codebase.
- Run the tests if a test runner is available in the environment.
    - If tests fail, analyze the output and fix the issues (incorrect mocks, wrong assertions, missing setup).
    - If you cannot run tests (missing runner, build failures, permission issues), output the test code with a note about any uncertainties.

The code to generate tests for is #{buffer}
