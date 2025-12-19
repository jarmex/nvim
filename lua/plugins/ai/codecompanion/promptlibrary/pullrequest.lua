-- prompt from https://github.com/hesreallyhim/awesome-claude-code/blob/main/resources/slash-commands/create-pr/create-pr.md

local prPrompt = [[
# Create Pull Request Command

Create a new branch, commit changes, and submit a pull request.

## Behavior
- Creates a new branch based on current changes
- Formats modified files using Biome
- Analyzes changes and automatically splits into logical commits when appropriate
- Each commit focuses on a single logical change or feature
- Creates descriptive commit messages for each logical unit
- Pushes branch to remote
- Creates pull request with proper summary and test plan

## Guidelines for Automatic Commit Splitting
- Split commits by feature, component, or concern
- Keep related file changes together in the same commit
- Separate refactoring from feature additions
- Ensure each commit can be understood independently
- Multiple unrelated changes should be split into separate commits
]]

return {
  interaction = 'chat',
  description = 'Generate a Pull Request message description',
  opts = {
    index = 18,
    is_default = false,
    alias = 'pr',
    is_slash_cmd = true,
    auto_submit = true,
  },
  prompts = {
    {
      role = 'user',
      contains_code = true,
      content = function()
        return 'You are an expert at writing detailed and clear pull request descriptions.'
          .. 'Please create a pull request message following standard convention from the provided diff changes.'
          .. 'Ensure the title, description, type of change, checklist, related issues, and additional notes sections are well-structured and informative.'
          .. '\n\n```diff\n'
          .. vim.fn.system('git diff $(git merge-base HEAD main)...HEAD')
          .. vim.fn.system('git diff $(git merge-base HEAD develop)...HEAD')
          .. '\n```'
      end,
    },
  },
}
