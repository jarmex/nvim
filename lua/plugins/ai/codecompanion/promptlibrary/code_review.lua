-- get_pull_request_diff
local codeReviewText = [[
You are conducting a thorough code review focused on security, code conventions, and design patterns.

Please analyze the code changes and provide:

## High-Level Assessment
- Architectural decisions and design pattern usage
- Adherence to functional programming principles (small functions, composition over inheritance)
- Overall code organization and maintainability

## Security & Critical Issues
- Security vulnerabilities, data validation, authentication/authorization gaps
- Breaking changes, data integrity concerns
- Error handling and edge case coverage

## Code Quality & Conventions
- Idiomatic language/framework usage
- Function size (target <20 lines), nesting levels (max 3), naming clarity
- Early returns, explicit over implicit patterns
- Library choices and deprecation concerns

## Design Patterns & Architecture
- Appropriate use of composition, currying/partial application
- Separation of concerns and single responsibility
- Integration patterns and API design

## Positive Highlights
- Well-implemented solutions, clever approaches, good pattern usage

## Questions & Discussion Points
- Areas needing clarification or alternative approaches
- Context about business requirements or constraints

Focus on being constructive and educational. Explain reasoning behind feedback, especially for architectural decisions.

#{buffer}

]]

return {
  strategy = 'chat',
  description = 'Review some code for me, please',
  opts = {
    is_slash_cmd = true,
    auto_submit = false,
    alias = 'code_review',
  },
  prompts = {
    { role = 'user', content = codeReviewText },
  },
}
