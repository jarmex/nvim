-- adapt from https://github.com/3ZsForInsomnia/dotfiles/blob/b9592b901be95d3ee74386fe4eb42ff20749ce6a/neovim/.config/nvim/lua/config/codecompanion-variables.lua
-- CodeCompanion variable definitions for chat and inline strategies
-- These variables can be referenced in prompts using #{variableName} syntax

local M = {}

-- Current date in YYYY-MM-DD Weekday format
M.date = {
  desc = 'Current date in YYYY-MM-DD Weekday format',
  callback = function()
    return os.date('%Y-%m-%d %A')
  end,
}
-- VectorCode Route Charter Header
M.vccharter = {
  description = 'VectorCode routing charter for multi-collection queries',
  callback = function()
    return [[
=== VectorCode Collection Router ===
Use these rules to select the project_root value for @vectorcode_query based on query intent.
Default: If no project_root specified, @vectorcode_query uses the current git root.

]]
  end,
}

-- VectorCode Current Project Entry
M.vccurrproj = {
  description = 'Current project collection for VectorCode routing',
  callback = function()
    local cwd = vim.fn.getcwd()
    local git_root
    local ok = pcall(function()
      local out = vim.fn.systemlist({ 'git', '-C', cwd, 'rev-parse', '--show-toplevel' })
      if type(out) == 'table' and out[1] and out[1] ~= '' then
        git_root = out[1]
      end
    end)
    if not ok or not git_root then
      git_root = cwd
    end
    return string.format(
      [[
Query Current Project using %s when querying:
- Code patterns, implementations, architecture, API designs, service structures, data models
- Existing functions, modules, related files, technical documentation, inline comments
- Test files, CI/CD configurations, deployment scripts, version history

]],
      git_root
    )
  end,
}

-- VectorCode Notes Collection Entry
M.vcnotes = {
  description = 'Notes collection for VectorCode routing',
  callback = function()
    local notes = vim.fn.expand('~/Documents/sync')
    return string.format(
      [[
Query Notes Collection using %s when querying:
- Meeting notes, project decisions, retrospectives, past conversations, planning notes
- Technical documentation, ADRs, design discussions, architecture decisions
- Personal research, learning resources, references, status updates

]],
      notes
    )
  end,
}

-- VectorCode Work Codebase Entry
M.vcwork = {
  description = 'Work codebase collection for VectorCode routing',
  callback = function()
    local work_root = os.getenv('W_PATH') .. '/platform'
    return string.format(
      [[
Query Work Codebase using %s when querying:
- Work-specific code patterns, microservice implementations, production API designs
- Work service structures, shared libraries, architecture decisions, existing work functions
- Work CI/CD pipelines, deployment configurations, version/release management

]],
      work_root
    )
  end,
}

-- Quick query: Notes collection
M.qnotes = {
  description = 'Quick command to query notes collection',
  callback = function()
    local notes = vim.fn.expand('~/Documents/sync')
    return string.format('@vectorcode_query project_root="%s"', notes)
  end,
}

-- Quick query: Work codebase
M.qwork = {
  description = 'Quick command to query work codebase',
  callback = function()
    local work_root = os.getenv('W_PATH') .. '/platform'
    return string.format('@vectorcode_query project_root="%s"', work_root)
  end,
}

return M
