---
name: Review Project Structure
interaction: chat
description: Assess how this project should be structured at a high level, using reputable production examples where relevant.
opts:
  alias: review-project-structure
  auto_submit: false
  is_slash_cmd: true
  stop_context_insertion: true
---

## user

Review how this project should be structured at a high level. Do not write code or edit files unless I explicitly ask.

Inspect the current repository structure first. Focus on folder layout, module boundaries, config placement, secrets boundaries, documentation split, testing strategy, CI/CD, and other production-facing structure decisions.

If the project fits a known category, reference reputable real-world projects or official templates that are actually used in production. Ignore toy repos and one-off home projects. Explain which structure choices are worth copying and which are not.

Return a practical recommendation for how this project should be organized, what should live where, and what important project-level docs or operational pieces may be missing.
