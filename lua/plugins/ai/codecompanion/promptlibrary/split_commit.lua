-- adated from https://github.com/lucobellic/nvim-config/blob/main/lua/plugins/codecompanion/prompts.lua
return {
  ['Split Commits'] = {
    strategy = 'chat',
    description = 'agent mode with explicit set of tools',
    opts = {
      index = 21,
      is_default = false,
      alias = 'commits',
      is_slash_cmd = true,
      auto_submit = false,
    },
    prompts = {
      {
        role = 'user',
        contains_code = true,
        content = function()
          local current_branch = vim.fn.system('git rev-parse --abbrev-ref HEAD')
          local logs = vim.fn.system('git log --pretty=format:"%s%n%b" -n 50')
          local commit_history = 'Commit history for branch ' .. current_branch .. ':\n' .. logs .. '\n\n'
          local staged_changes = 'Staged files:\n' .. vim.fn.system('git diff --cached --name-only')
          local prompt = '<prompt>' .. commit_history .. staged_changes .. '</prompt> \n\n'
          local task = 'You are an expert Git assistant.\n'
            .. 'Your task is to help the user create well-structured and conventional commits from their currently staged changes.\n\n'
            .. 'Based on the provided commit logs and branch name, first, infer the established commit message convention\n'
            .. 'Next, use the staged changes to determine the logical grouping of changes and generate appropriate commit messages.\n\n'
            .. 'Your primary goal is to analyze these staged changes and determine if they should be split into multiple logical and separate commits.\n'
            .. 'If the staged changes are empty or too trivial for a meaningful commit, please state that.\n\n'
            .. 'Use @{cmd_runner} to execute git commands for staging and un-staging files to group staged changes into meaningful commits when necessary.'
          return prompt .. task
        end,
      },
    },
  },
  ['qflist'] = {
    strategy = 'chat',
    description = 'Send errors to qflist and diagnostics',
    opts = {
      index = 23,
      is_default = false,
      alias = 'qflist',
      is_slash_cmd = true,
      auto_submit = false,
    },
    prompts = {
      {
        role = 'user',
        contains_code = true,
        content = function()
          local content =
            'Create a neovim command line for `:` to send the current errors to qflist and diagnostics using neovim api.\n'
          local example = [[
                :lua do local ns = vim.api.nvim_create_namespace('review');

                  -- For each files:
                  local bufnr = vim.fn.bufnr('/full/path/to/your/file.txt');
                  if bufnr ~= -1 then
                    local diagnostics = {{bufnr=bufnr, lnum=324, col=0, message='This is the ErrorMessage', severity=vim.diagnostic.severity.ERROR}};
                    vim.diagnostic.set(ns, bufnr, diagnostics);
                    vim.fn.setqflist(vim.diagnostic.toqflist(diagnostics), 'a');
                  end
                end
                ]]
          return content .. '\nExample:\n' .. example:gsub('\n', ' '):gsub(' +', ' ')
        end,
      },
    },
  },
  ['agent'] = {
    strategy = 'inline',
    description = 'Ask agent',
    opts = {
      index = 24,
      is_default = false,
      alias = 'agent',
      is_slash_cmd = false,
      auto_submit = true,
      user_prompt = true,
      adapter = {
        name = 'copilot',
        model = 'gpt-4.1',
      },
    },
    prompts = {
      {
        role = 'user',
        contains_code = true,
        content = function(context)
          local buffer = '#{buffer}\n'
          local tools = '@{cmd_runner} @{files} @{insert_edit_into_file}\n'
          return buffer
            .. tools
            .. require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)
        end,
      },
    },
  },
}
