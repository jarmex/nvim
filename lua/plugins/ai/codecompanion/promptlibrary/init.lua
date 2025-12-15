local markdown = {
  dirs = {
    vim.fn.getcwd() .. '/.prompts',
    '~/.dotfiles/.config/prompts',
  },
}
local prompt_library = {
  ['Add DocBlock'] = require('plugins.ai.codecompanion.promptlibrary.docblock'),
  ['Agent-Mode Current Buffer'] = require('plugins.ai.codecompanion.promptlibrary.agent_mode'),
  ['Code review'] = require('plugins.ai.codecompanion.promptlibrary.code_review'),
  ['Explain architecture'] = require('plugins.ai.codecompanion.promptlibrary.explain_architecture'),
  ['Explain code'] = require('plugins.ai.codecompanion.promptlibrary.explain_code'),
  ['Fix LSP Diagnostics'] = require('plugins.ai.codecompanion.promptlibrary.fix_lsp'),
  ['Document Code'] = require('plugins.ai.codecompanion.promptlibrary.doc_string'),
  ['Naming'] = require('plugins.ai.codecompanion.promptlibrary.naming'),
  ['Refactor'] = require('plugins.ai.codecompanion.promptlibrary.refactor'),
  ['Review'] = require('plugins.ai.codecompanion.promptlibrary.review'),
  ['Suggest Refactoring'] = require('plugins.ai.codecompanion.promptlibrary.suggest_refactoring'),
  ['Linear Feature Ticket'] = require('plugins.ai.codecompanion.promptlibrary.linear-feat-ticket'),
  ['Linear Bug Ticket'] = require('plugins.ai.codecompanion.promptlibrary.linear-bug-ticket'),
}

local commit_pull_request = require('plugins.ai.codecompanion.promptlibrary.commit_pull_request')
local linearReleaseNote = require('plugins.ai.codecompanion.promptlibrary.linear_release_notes')
local others = require('plugins.ai.codecompanion.promptlibrary.others')
local pr_review_prompt = require('plugins.ai.codecompanion.promptlibrary.review_pull_request')
local retrieval = require('plugins.ai.codecompanion.promptlibrary.retrieval')
local review_documents = require('plugins.ai.codecompanion.promptlibrary.review_documentation')
local testgenerator = require('plugins.ai.codecompanion.promptlibrary.test_generator')

return vim.tbl_extend(
  'force',
  {},
  prompt_library,
  review_documents,
  commit_pull_request,
  others,
  retrieval,
  pr_review_prompt,
  testgenerator,
  linearReleaseNote,
  markdown -- experimental
)
