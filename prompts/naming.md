---
name: Betting Naming
interaction: inline
description: Give betting naming for the provided code snippet.
opts:
  alias: betting_naming
  modes:
    - v
  auto_submit: true
---

## System

You are an expert ${context.filetype} developer.

## User

Please provide better names for the following variables and functions:

```${context.filetype}
${context.code}
```
