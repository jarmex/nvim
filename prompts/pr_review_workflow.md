---
name: PR Review Workflow
description: "Multi-step PR review: fetch context → security → quality → verdict"
interaction: chat
mcp_servers:
  - linear
opts:
  is_workflow: true
  alias: pr_review_workflow
  is_slash_cmd: true
  adapter:
    name: copilot
    model: claude-haiku-4.5
---
<!-- Step 1: Fetch all PR context -->

## user

@{run_command}
Fetch the following context and confirm what you found before proceeding:

1. Run: `gh pr view --json number,title,body,state,author,baseRefName,headRefName,labels,additions,deletions,changedFiles`
2. Run: `gh pr diff`
3. If a Linear ticket ID (pattern `[A-Z]+-\d+`) is in the PR title/body/branch, fetch it: @{linear}

Summarize: PR title, description, changed files count, and Linear ticket summary (if found).

Enter the PR number to fetch context for: `#`

## user

<!-- Step 2: Security analysis -->

```yaml opts
auto_submit: true
```

Based on the PR diff above, perform a focused **security review only**.

Check for:

- Input validation (injection, XSS, command injection)
- AuthN/AuthZ on all new endpoints or jobs
- Hardcoded secrets or tokens
- Insecure defaults (CORS, TLS, cookies)
- PII in logs or error responses
- Vulnerable dependencies introduced

Format each finding as:
**Severity**: Blocking | Major | Minor
**Location**: file:line
**Issue**: description
**Fix**: specific solution

State "No security issues found" if clean.

## user

<!-- Step 3: Code quality + architecture -->

```yaml opts
auto_submit: true
```

Now review **code quality and architecture** for the same diff.

Cover:

- Design patterns and separation of concerns
- Function complexity (target <20 lines, nesting ≤3)
- Error handling and null safety
- Performance concerns (N+1 queries, blocking I/O, large payloads)
- Test coverage gaps

Anchor all feedback to `file:line`. Be specific and actionable.

## user

<!-- Step 4: Final verdict (auto_submit false so you can review before sending) -->

```yaml opts
adapter:
  name: copilot
  model: claude-haiku-4.5
auto_submit: false
```

Given your findings above, give the final review verdict:

**Decision**: Approve | Approve with nits | Request changes

If requesting changes, list **required** (blocking) vs **suggested** (nit) items.

End with a "Definition of Done" checklist:

- [ ] No blocking security issues
- [ ] Tests cover new logic and critical paths
- [ ] No secrets; PII handled properly
- [ ] Breaking changes documented
- [ ] Observability added for new code paths
