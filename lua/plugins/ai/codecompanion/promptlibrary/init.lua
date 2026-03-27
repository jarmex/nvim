local prompt_library = {
  ['Code review'] = require('plugins.ai.codecompanion.promptlibrary.code_review'),
  ['Review'] = require('plugins.ai.codecompanion.promptlibrary.review'),
  markdown = {
    dirs = {
      vim.fn.getcwd() .. '/.prompts',
      vim.fn.stdpath('config') .. '/prompts',
    },
  },
}

local commit_pull_request = require('plugins.ai.codecompanion.promptlibrary.commit_pull_request')
-- local linearReleaseNote = require('plugins.ai.codecompanion.promptlibrary.linear_release_notes')
local others = require('plugins.ai.codecompanion.promptlibrary.others')
local pr_review_prompt = require('plugins.ai.codecompanion.promptlibrary.review_pull_request')
local review_documents = require('plugins.ai.codecompanion.promptlibrary.review_documentation')
-- local testgenerator = require('plugins.ai.codecompanion.promptlibrary.test_generator')

return vim.tbl_extend(
  'force',
  {},
  review_documents,
  commit_pull_request,
  others,
  pr_review_prompt,
  -- testgenerator,
  -- linearReleaseNote,
  prompt_library
)
