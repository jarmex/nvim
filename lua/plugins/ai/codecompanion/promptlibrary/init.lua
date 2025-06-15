local promptList = require('plugins.ai.codecompanion.promptlibrary.awesome-prompts')

return vim.tbl_extend('force', promptList.prompt_library(), {
  ['Add DocBlock'] = require('plugins.ai.codecompanion.promptlibrary.docblock'),
  ['Agent Mode'] = require('plugins.ai.codecompanion.promptlibrary.agent_mode'),
  ['Bug Finder'] = require('plugins.ai.codecompanion.promptlibrary.bug_finder'),
  ['Code Expert'] = require('plugins.ai.codecompanion.promptlibrary.code_expert'),
  ['Code review'] = require('plugins.ai.codecompanion.promptlibrary.code_review'),
  ['Explain architecture'] = require('plugins.ai.codecompanion.promptlibrary.explain_architecture'),
  ['Explain code'] = require('plugins.ai.codecompanion.promptlibrary.explain_code'),
  ['Fix LSP Diagnostics'] = require('plugins.ai.codecompanion.promptlibrary.fix_lsp'),
  ['Generate Docstring'] = require('plugins.ai.codecompanion.promptlibrary.doc_string'),
  ['Generate a Commit Message for Staged Files'] = require('plugins.ai.codecompanion.promptlibrary.scommit'),
  ['Git Diff Code Review'] = require('plugins.ai.codecompanion.promptlibrary.git_diff_code_review'),
  ['Naming'] = require('plugins.ai.codecompanion.promptlibrary.naming'),
  ['Platform Commit'] = require('plugins.ai.codecompanion.promptlibrary.platform-commit'),
  ['Proof Read'] = require('plugins.ai.codecompanion.promptlibrary.proofread'),
  ['Pull Request'] = require('plugins.ai.codecompanion.promptlibrary.pullrequest'),
  ['Refactor'] = require('plugins.ai.codecompanion.promptlibrary.refactor'),
  ['Review'] = require('plugins.ai.codecompanion.promptlibrary.review'),
  ['Spell'] = require('plugins.ai.codecompanion.promptlibrary.spell'),
  ['Suggest Refactoring'] = require('plugins.ai.codecompanion.promptlibrary.suggest_refactoring'),
  ['Vibe Code'] = require('plugins.ai.codecompanion.promptlibrary.vibe_code'),
  ['inline'] = require('plugins.ai.codecompanion.promptlibrary.inline'),
  [' Lua Developer'] = require('plugins.ai.codecompanion.promptlibrary.lua_developer'),
  [' Python Developer'] = require('plugins.ai.codecompanion.promptlibrary.python_dev'),
  ['Edit'] = {
    strategy = 'chat',
    description = 'Edit the current buffer',
    prompts = {
      { role = 'user', content = '@insert_edit_into_file #buffer\n\n' },
    },
    opts = {
      auto_submit = false,
      short_name = 'edit',
      is_slash_cmd = true,
    },
  },
  ['Develop'] = {
    strategy = 'chat',
    description = 'Edit with full tooling',
    prompts = {
      { role = 'user', content = '@full_stack_dev #buffer\n\n' },
    },
    opts = {
      auto_submit = false,
      short_name = 'dev',
      is_slash_cmd = true,
    },
  },
})
