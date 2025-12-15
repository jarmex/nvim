local pull_request_path = vim.fn.stdpath('config') .. '/.pull_request/'

return {
  ['Commit and PR'] = {
    strategy = 'workflow',
    description = 'Generate a commit, push the branch and create a PR.',
    opts = {
      alias = 'commit-and-pr',
      adapter = 'copilot',
    },
    context = {
      {
        type = 'file',
        path = {
          pull_request_path .. 'pull_request_template.md',
          -- '.github/pull_request_template.md',
          -- '.vscode/settings.json',
        },
      },
    },
    prompts = {
      {
        {
          role = 'system',
          content = [[You are an expert creating commits using the conventional commit format. You know exactly how to generate a commit message based on any provided diff. You're also an expert in creating pull requests using the GitHub CLI.]],
          opts = {
            visible = false,
          },
        },
        {
          role = 'user',
          content = function()
            return string.format(
              [[I want you to use the @{cmd_runner} tool to create a commit using the conventional commit format. Make sure to:
1. Use the provided diff to generate a commit message.
2. Write only the header (no detailed description and no scope).
3. Ensure the message is clear, relevant, and properly formatted.
4. DO NOT run git add, as all the changes is provided and already staged.

Here is the diff:

```diff
%s
```]],
              vim.fn.system('git diff --no-ext-diff --staged')
            )
          end,
          opts = {
            contains_code = true,
            auto_submit = true,
          },
        },
      },
      {
        {
          role = 'user',
          content = 'Checkout to a new branch with a relevant name based on the commit message.',
          opts = {
            contains_code = false,
            auto_submit = true,
          },
        },
      },
      {
        {
          role = 'user',
          content = 'Push the new created and switched branch to the remote repository using the --set-upstream flag.',
          opts = {
            contains_code = false,
            auto_submit = true,
          },
        },
      },
      {
        {
          role = 'user',
          content = [[Create a pull request using GitHub CLI:
- Use the provided diff to fill out the PR body according to the given template.
- Scape correctly the crasis symbol (```) in the body.
- Set the base branch to main.
- Assign an appropriate label from refactoring, feature, fix, or chore, based on the changes.
- Set the assignee to @me.
- Generate a clear, first word capitalized title based on the commit message, but do not use the Conventional Commit format—use a plain descriptive title instead.

Execute these steps precisely and efficiently.]],
          opts = {
            contains_code = false,
            auto_submit = false,
          },
        },
      },
    },
  },
}
