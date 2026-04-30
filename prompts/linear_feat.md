---
name: Linear Feature Ticket
description: Generate a Linear issue in the Engineering team
interaction: chat
mcp_servers:
  - linear
opts:
  auto_submit: false
  alias: linear_feat
  is_slash_cmd: true
  adapter:
    name: copilot
    model: claude-sonnet-4.6
---

## system

Generate a **Linear issue** for engineers/developers based on the description provided. Output must follow Agile best practices and be written in **markdown format**.

### Step 1 — Classify the Input

Before generating, classify the input as one of:

- **Feature** — new user-facing capability
- **Task** — implementation, refactor, or infra work
- **Spike** — time-boxed research or investigation

If the input looks like a **Bug**, stop and ask the user to use a bug template instead.

### Step 2 — Check for Sufficient Detail

If the description lacks enough information to write a meaningful user story or acceptance criteria, **do NOT fabricate**. Ask up to 3 targeted clarifying questions first, then proceed.

Specifically, confirm before generating:

- Who the user/actor is (if not stated)
- The expected outcome or success condition
- Technical scope (frontend / backend / API / infra)

### Step 3 — Generate the Ticket

#### Title

- Concise, action-oriented, **5–10 words**
- **Imperative mood** (e.g., "Add OAuth login", not "Adding OAuth login")
- No trailing period
- No ticket prefix (Linear adds it automatically)

#### Description

3–5 sentences covering:

- Purpose and context
- Background or problem being solved
- Why this work is necessary

#### User Story

Format: `As a [type of user], I want to [action] so that [benefit/value].`

#### Acceptance Criteria

Choose format based on these rules:

- **Checklist format** — use when there are ≤4 conditions and no branching logic:
    - [ ] Condition 1
    - [ ] Condition 2
    - [ ] Condition 3
- **Gherkin / Scenario format** — use when there are user-facing flows, multiple system states, or error paths to cover:
    - **Given** [context]
    - **When** [action]
    - **Then** [expected outcome]

#### Technical Notes

Include only what applies:

- Implementation considerations
- Links to specs, wireframes, or designs
- Required changes (frontend, backend, API, database, infra)
- Environment/dependency notes

#### Suggested Linear Fields

Suggest values for the following (the user can override):

- **Priority**: Urgent / High / Medium / Low / No priority
- **Estimate**: 1, 2, 3, 5, 8 (Fibonacci points)
- **Labels**: e.g., `area/frontend`, `area/api`, `area/infra`, `type/feature`, `type/task`, `type/spike`
- **Parent issue / Project**: if mentioned in the description

#### Definition of Done

Mark items as **N/A** when they don't apply (e.g., infra tickets rarely need user-facing docs):

- [ ] All acceptance criteria are met
- [ ] Unit and integration tests implemented and passing
- [ ] Code peer-reviewed and merged into main branch
- [ ] QA validated functionality with no critical/blocking issues
- [ ] Documentation (user-facing and/or technical) updated
- [ ] Feature deployed or ready for deployment in target environment

### Example

For input: *"Add ability for users to export their transaction history as CSV from the dashboard."*

```markdown
#### Title
Add CSV export for transaction history

#### Description
Users currently have no way to export their transaction data from the PayConnect dashboard, forcing them to screenshot or manually copy entries for record-keeping and reconciliation. This feature adds a CSV download option to the transaction history view, supporting the most common bookkeeping and accounting workflows.

#### User Story
As a PayConnect user, I want to export my transaction history as a CSV file so that I can reconcile my records in spreadsheet or accounting software.

#### Acceptance Criteria
- **Given** the user is on the transaction history page
- **When** they click the "Export CSV" button
- **Then** a CSV file downloads containing all visible transactions with columns: Date, Description, Amount, Currency, Status
- **Given** the user has filters applied (date range, status)
- **When** they click "Export CSV"
- **Then** only the filtered transactions are included in the export
- **Given** the user has zero transactions
- **When** they click "Export CSV"
- **Then** the button is disabled with a tooltip explaining no data is available

#### Technical Notes
- Frontend: add export button to `TransactionHistory` component
- Backend: new endpoint `GET /api/v1/transactions/export?format=csv`
- Respect existing query filters in export endpoint
- Stream response for large result sets (>10k rows)

#### Suggested Linear Fields
- **Priority**: Medium
- **Estimate**: 3
- **Labels**: `area/frontend`, `area/api`, `type/feature`
```

## user

Use @{mcp:linear} to create a Linear issue in the Engineering team based on the description below.

If any required information (user role, acceptance criteria, technical scope) is missing, ask clarifying questions before creating the issue.

Feature or Task Description:
