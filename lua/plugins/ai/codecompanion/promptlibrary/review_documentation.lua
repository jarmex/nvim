-- https://github.com/codybuell/dotfiles/blob/master/dotfiles/config/nvim/lua/buell/codecompanion/prompt_library.lua
local M = {}

--------------------------------------------------------------------------------
--                                                                            --
--  Review Documentation                                                      --
--                                                                            --
--  A core workflow prompt for maintaining living documentation.              --
--  This implements the "CREATE" step of the documentation feedback loop      --
--  by analyzing the current codebase against existing documentation and      --
--  suggesting specific, actionable updates.                                  --
--                                                                            --
--  Workflow:                                                                 --
--    1. Checks for missing essential documentation files                     --
--    2. Creates missing files using templates if needed                      --
--    3. Loads existing documentation files as context                        --
--    4. Analyzes code for gaps, outdated info, missing decisions             --
--    5. Presents recommendations in checkbox format for user approval        --
--    6. Updates approved items using file creation/editing tools             --
--                                                                            --
--  Triggered by: <leader>dr or :CodeCompanion review_docs                    --
--  Expected frequency: Weekly or after significant code changes              --
--                                                                            --
--------------------------------------------------------------------------------

M['Review Documentation'] = {
  strategy = 'chat',
  description = 'Analyze codebase and suggest documentation updates',
  opts = {
    alias = 'review_docs',
    auto_submit = false,
  },
  context = {
    {
      type = 'file',
      path = 'codecompanion-workspace.json',
      optional = true,
    },
    {
      type = 'file',
      path = 'doc/project-context.md',
      optional = true,
    },
    {
      type = 'file',
      path = 'doc/decisions.md',
      optional = true,
    },
    {
      type = 'file',
      path = 'doc/tech-context.md',
      optional = true,
    },
  },
  prompts = {
    {
      role = 'system',
      content = [[You are a documentation reviewer. Your job is to:

1. **CHECK**: Verify essential documentation files exist
2. **ANALYZE**: Compare current documentation with codebase
3. **RECOMMEND**: Present specific, actionable updates in checkbox format
4. **CREATE**: Use @{create_file} for missing essential files
5. **WAIT**: Always get user approval before making changes
6. **IMPLEMENT**: Only update items the user approves

If essential documentation files don't exist, create them first using the templates from the "Initialize Living Docs" prompt.

Focus on:
- Missing architectural decisions that should be documented
- Outdated technical information
- New patterns or conventions that emerged
- Gaps between code and documentation]],
    },
    {
      role = 'user',
      content = [[Please review the documentation for this project.

First, use @{file_search} to check what documentation exists. If essential files (project-context.md, decisions.md, tech-context.md, codecompanion-workspace.json) are missing, create them using @{create_file} with appropriate templates.

Then analyze existing documentation against the codebase using @{file_search} and @{grep_search} tools.

Present findings as:

## Documentation Review

### Missing Essential Files
- [ ] **File**: Why it's needed

### Documentation Recommendations

### Missing Documentation
- [ ] **Topic/File**: Specific recommendation and rationale

### Outdated Information
- [ ] **Section**: What needs updating and why

### Decision Gaps
- [ ] **Decision**: What should be captured in decisions.md

### Pattern Documentation
- [ ] **Pattern**: What coding patterns need documentation

After I approve items, implement them using @{create_file} or @{insert_edit_into_file}.]],
    },
  },
}

return M
