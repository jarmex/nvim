---
name: Linear Feature Ticket
description: Generate a Linear issue in the Engineering team
interaction: chat
tools:
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

Generate a **feature ticket or task** for engineers/developers based on the description provided. The output must follow Agile best practices and be written in **markdown format** for clarity.

### Structure to Follow

#### Title

Provide a concise, action-oriented summary of the feature or task (5–10 words).

#### Description

Give a high-level explanation of the feature or task:

* Purpose and context
* Background or problem being solved
* Why this work is necessary

#### User Story

Write in the following format:
As a [type of user], I want to [action] so that [benefit/value].

#### Acceptance Criteria

Choose the appropriate style based on task complexity:

* **For small tasks → Checklist/Rules format**

    * [ ] Condition 1
    * [ ] Condition 2
    * [ ] Condition 3

* **For complex flows → Scenario-Based or Gherkin format**

  **Scenario-Based:**

    * A user does X, and the system responds with Y
    * A user attempts invalid input, and the system rejects with error Z

  **Gherkin-Style (optional):**

    * Given [context]
    * When [action]
    * Then [expected outcome]

#### Technical Notes

Include any relevant technical details:

* Implementation considerations
* Links to specs, wireframes, or designs
* Required changes (frontend, backend, API, database, infra, etc.)
* Environment/dependency notes

#### Definition of Done (DoD) Checklist

Every task is considered complete only when:

* [ ] All acceptance criteria are met
* [ ] Unit and integration tests are implemented and passing
* [ ] Code is peer-reviewed and merged into main branch
* [ ] QA has validated functionality with no critical/blocking issues
* [ ] Documentation (user-facing and/or technical) is updated
* [ ] Feature is deployed or ready for deployment in the target environment

## user

Use the @{linear} tool to create a Linear issue in the Engineering team.

Feature or Task Description Input below:
