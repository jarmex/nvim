--https://github.com/codybuell/dotfiles/blob/master/dotfiles/config/nvim/lua/buell/codecompanion/prompt_library.lua

local M = {}

--------------------------------------------------------------------------------
--                                                                            --
--  Initialize Living Documentation                                           --
--                                                                            --
--  The foundational workflow prompt that bootstraps the living               --
--  documentation system for new or existing projects. This sets up the       --
--  essential documentation infrastructure and workspace configuration        --
--  needed for the complete living documentation feedback loop.               --
--                                                                            --
--  Workflow:                                                                 --
--    1. Scans project structure using file search tools                      --
--    2. Identifies missing essential documentation files                     --
--    3. Creates missing files using appropriate templates                    --
--    4. Sets up codecompanion-workspace.json with project-specific config    --
--    5. Customizes templates based on detected project technologies          --
--    6. Preserves any existing documentation (safe, non-destructive)         --
--                                                                            --
--  Safety: Only creates missing files - never overwrites existing docs       --
--                                                                            --
--  Triggered by: <leader>di or :CodeCompanion init_docs                      --
--  Expected frequency: Once per project (setup phase)                        --
--                                                                            --
--------------------------------------------------------------------------------

M['Initialize Living Docs'] = {
  interaction = 'chat',
  description = 'Initialize living documentation workflow for a new project',
  opts = {
    alias = 'init_docs',
    auto_submit = false,
  },
  prompts = {
    {
      role = 'system',
      content = [[You help initialize the living documentation workflow for projects. Your tasks:

1. **ASSESS**: Check what documentation already exists using @{file_search}
2. **CREATE**: Create missing essential documentation files with appropriate templates using @{create_file}
3. **SETUP**: Create or update the codecompanion-workspace.json file

IMPORTANT: Only create files that don't already exist. Never overwrite existing documentation.

Essential files for living documentation:
- doc/project-context.md (project overview and goals)
- doc/decisions.md (architectural decision records)
- doc/tech-context.md (technology choices and patterns)
- codecompanion-workspace.json (AI context configuration)

Use the @{create_file} tool to create missing files with appropriate templates.]],
    },
    {
      role = 'user',
      content = [[Please initialize the living documentation workflow for this project.

First, use @{file_search} to check what documentation already exists. Only create files that are missing - never overwrite existing documentation.

For doc/project-context.md, use this template:
```markdown
# [Project Name]

## Overview
Brief description of what this project does and why it exists.

## Goals & Objectives
- Primary objective 1
- Primary objective 2

## Constraints
- Technical constraints
- Business constraints

## Architecture Overview
High-level system design and key components.

## Key Technologies
- Technology 1: Rationale
- Technology 2: Rationale

## Related Documentation
- [Decisions](./decisions.md)
- [Tech Context](./tech-context.md)
```

For doc/decisions.md, use this template:
```markdown
# Architectural Decision Records

## Decision Template
When adding new decisions, use this format:

### [YYYY-MM-DD] - [Decision Title]
**Status:** Proposed | Accepted | Rejected | Superseded
**Context:** Why this decision was needed
**Decision:** What was decided
**Consequences:** Expected outcomes and trade-offs
**Tags:** #relevant #tags

## Decisions

### [Current Date] - Adopt Living Documentation Workflow
**Status:** Accepted
**Context:** Need systematic approach to keep documentation current with code changes
**Decision:** Implement living documentation workflow with AI assistance via CodeCompanion
**Consequences:**
- Better knowledge retention across team
- Easier onboarding for new developers
- Documentation stays aligned with codebase evolution
- Regular review cycles ensure accuracy
**Tags:** #documentation #workflow #ai-assisted
```

For doc/tech-context.md, use this template:
```markdown
# Technology Context

## Technology Stack
Document key technologies and rationale:
- **Language:** [Primary language and version]
- **Framework:** [Main framework if applicable]
- **Database:** [Database technology]
- **Deployment:** [Deployment approach]

## Architecture Patterns
Document key patterns as they emerge:
- Pattern 1: Description and usage
- Pattern 2: Description and usage

## Conventions
### Naming Conventions
- Files: [convention]
- Functions: [convention]
- Variables: [convention]

### Code Organization
Describe how code is structured and organized.

## Key Dependencies
Major dependencies and selection rationale:
- **Dependency 1:** Why chosen, alternatives considered
- **Dependency 2:** Why chosen, alternatives considered

## Development Setup
Basic setup requirements and configuration.
```

For codecompanion-workspace.json, create a minimal configuration:
```json
{
  "name": "[Detected Project Name]",
  "version": "1.0.0",
  "system_prompt": "This project follows a living documentation workflow. Always consult the ${docs_path}/ folder for project context, decisions, and patterns before providing advice.",
  "vars": {
    "docs_path": "doc"
  },
  "groups": [
    {
      "name": "Core Architecture",
      "system_prompt": "Essential project understanding - review before architectural changes",
      "data": ["project-overview", "decisions", "tech-stack"]
    }
  ],
  "data": {
    "project-overview": {
      "type": "file",
      "path": "${docs_path}/project-context.md",
      "description": "High-level project goals and architecture"
    },
    "decisions": {
      "type": "file",
      "path": "${docs_path}/decisions.md",
      "description": "Technical decisions and rationale"
    },
    "tech-stack": {
      "type": "file",
      "path": "${docs_path}/tech-context.md",
      "description": "Technology stack and patterns"
    }
  }
}
```

Customize the templates based on what you discover about the project structure and technologies used.]],
    },
  },
}

return M
