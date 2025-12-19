-- get_pull_request_diff
local get_pull_request_diff = [[
You are conducting a **security-focused, pragmatic code review**. Output must be **succinct, line-specific, and actionable**.

---

## Context Retrieval (Run in Order)

1. **Repository Info**
   ```bash
   git remote get-url origin | sed 's/.*github\.com[:/]\([^/]*\)\/\([^/.]*\).*/\1 \2/'
   ```
   Capture: `repo_owner`, `repo_name`

2. **Pull Request Data**
   - Fetch PR: `@{github__get_pull_request}`
   - Fetch diff: `@{github__get_pull_request_diff}`

3. **Linear Ticket** (if referenced in PR title/body/branch)
   - Parse for pattern: `[A-Z]+-\d+` (e.g., `PAY-123`)
   - If found: `@{linear__get_issue}`
   - If not found: state "No Linear ticket referenced"

4. **Error Handling**: If tools fail, continue review with available data and note gaps.

---

## Output Format

### 1. TL;DR
- **Verdict**: Approve | Approve with nits | Request changes
- **Top 3 Risks**: Security/behavior/regression concerns
- **Ticket Alignment** (if Linear ticket exists):
  - ✅/❌ Problem statement matches changes
  - ✅/❌ Acceptance criteria satisfied (list gaps)
  - ✅/❌ No scope creep

### 2. Change Summary
- **What**: Brief description from PR + diff
- **Size**: Small (<100 LOC, <5 files) | Medium (100-500 LOC, 5-15 files) | Large (>500 LOC, >15 files)
- **Impact**: Modules affected, breaking changes, migrations required

### 3. Security & Critical Issues
For each finding use:
```
**Severity**: Blocking | Major | Minor
**Location**: file:line(s)
**Issue**: [description]
**Fix**: [specific solution with code example if needed]
```

Check:
- Input validation (SQL/NoSQL injection, XSS, command injection)
- AuthN/AuthZ on endpoints, jobs, CLI commands
- Secrets (hardcoded credentials, tokens, keys)
- Insecure defaults (CORS, TLS, cookies, CSRF protection)
- PII in logs/errors; information disclosure
- Dependency vulnerabilities

### 4. Architecture & Design
- Patterns used and appropriateness
- Separation of concerns; clear boundaries
- API contracts (request/response, versioning, idempotency)
- Concurrency/transactions handling
- Performance concerns (N+1 queries, large payloads, blocking I/O)

### 5. Code Quality
- Language/framework idioms followed
- Function complexity (target: <20 lines, nesting ≤3)
- Clear naming, minimal side effects
- Error handling (null safety, proper error types)
- Line-specific nits: `file:line — suggestion`

### 6. Testing
- Coverage: happy path + edge cases + failures
- Security tests (invalid inputs, authZ checks)
- No flaky tests (real time/network without mocks)
- **Missing test cases**: [list specific scenarios to add]

### 7. Positives
Brief bullets on well-executed elements.

### 8. Questions
Specific clarifying questions (prefer yes/no format).

### 9. Final Decision
- **Approve** | **Approve with nits** | **Request changes**
- If blocking: list **required changes**

---

## Review Principles

**Security First**: Treat security and data integrity issues as blocking by default.

**Be Specific**: Always anchor feedback to `file:line` or diff hunk.

**Actionable**: Provide exact fixes, not generic advice. Show code snippets when helpful.

**Concise**: Keep review 600-900 words unless PR is Large (>500 LOC).

**Interpret, Don't Restate**: Analyze intent vs. requirements, don't just summarize the diff.

---

## Definition of Done

Before approving, verify:
- [ ] No blocking/major security issues
- [ ] Tests cover new logic and critical paths
- [ ] No secrets in code; PII handled properly
- [ ] Breaking changes documented
- [ ] Observability added for new code paths
- [ ] Rollback strategy noted for schema/behavior changes

---

## Example Finding

**Severity**: Major
**Location**: `api/order.go:142-160`
**Issue**: N+1 query in `ListOrders` - fetches items per order in loop
**Fix**: Use eager loading:
```go
// Replace row-by-row SELECT with:
db.Preload("Items").Where("account_id = ?", aid).Find(&orders)
```
]]

local codeReviewText = [[
You are a senior reviewer conducting a thorough, pragmatic code review with emphasis on security, code quality/conventions, and design/architecture. Your output must be succinct, line-anchored, and actionable.

You can fetch Linear ticket details if referenced: @{linear__get_issue}

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

First, let me get the repository information from git and fetch the PR details:

Run this command to get repo info: `git remote get-url origin | sed 's/.*github\.com[:/]\([^/]*\)\/\([^/.]*\).*/\1 \2/'`

Then I'll use that info to:
1. Get PR details: @{github__get_pull_request}
2. Check for Jira ticket in description: @{linear__get_issue} if referenced
3. Get the diff: @{github__get_pull_request_diff} for PR number:
]]

return {
  ['Review Pull Request With Linear'] = {
    interaction = 'chat',
    description = 'Review a Pull Request with referenced Linear ticket',
    opts = {
      is_slash_cmd = true,
      auto_submit = false,
      alias = 'pr_code_review',
    },
    prompts = {
      { role = 'user', content = get_pull_request_diff },
    },
  },
}
