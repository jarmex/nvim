-- local promptList = require('plugins.ai.codecompanion.promptlibrary.awesome-prompts')

-- local fabric = require('plugins.ai.codecompanion.promptlibrary.fabric').load_fabric_patterns()

-- local function chat_filter(chat_data)
--   -- TODO: check to remove this in future
--   return vim.g.project_root == chat_data.project_root or vim.g.project_root == chat_data.cwd
-- end
--
local prompt_library = {
  --- Reserve index intervals:
  ---     - 1-9       System (Chat, Open chats, Custom Prompt, Saved Chats, etc.)
  ---     - 100-199   User Inline Prompts
  ---     - 200-299   User Chat Prompts
  ---     - 300-399   User Workflows
  ---     - 400-499   fabric prompts
  ['Unit Tests'] = { opts = { index = 50 } },
  ['Fix code'] = { opts = { index = 150 } },
  ['Explain LSP Diagnostics'] = { opts = { index = 151 } },
  ['Explain'] = { opts = { index = 152 } },
  ['Generate a Commit Message'] = { opts = { index = 153 } },
  ['Workspace File'] = { opts = { index = 250 } },
  ['Code workflow'] = { opts = { index = 350 } },
  ['Edit<->Test workflow'] = { opts = { index = 351 } },

  ['Add DocBlock'] = require('plugins.ai.codecompanion.promptlibrary.docblock'),
  ['Agent-Mode Current Buffer'] = require('plugins.ai.codecompanion.promptlibrary.agent_mode'),
  ['Code review'] = require('plugins.ai.codecompanion.promptlibrary.code_review'),
  ['Explain architecture'] = require('plugins.ai.codecompanion.promptlibrary.explain_architecture'),
  ['Explain code'] = require('plugins.ai.codecompanion.promptlibrary.explain_code'),
  ['Fix LSP Diagnostics'] = require('plugins.ai.codecompanion.promptlibrary.fix_lsp'),
  ['Document Code'] = require('plugins.ai.codecompanion.promptlibrary.doc_string'),
  ['Naming'] = require('plugins.ai.codecompanion.promptlibrary.naming'),
  ['Platform Commit'] = require('plugins.ai.codecompanion.promptlibrary.platform-commit'),
  ['Proof Read'] = require('plugins.ai.codecompanion.promptlibrary.proofread'),
  ['Pull Request'] = require('plugins.ai.codecompanion.promptlibrary.pullrequest'),
  ['Refactor'] = require('plugins.ai.codecompanion.promptlibrary.refactor'),
  ['Review'] = require('plugins.ai.codecompanion.promptlibrary.review'),
  ['Spell'] = require('plugins.ai.codecompanion.promptlibrary.spell'),
  ['Suggest Refactoring'] = require('plugins.ai.codecompanion.promptlibrary.suggest_refactoring'),
  ['Linear Feature Ticket'] = require('plugins.ai.codecompanion.promptlibrary.linear-feat-ticket'),
  ['Linear Bug Ticket'] = require('plugins.ai.codecompanion.promptlibrary.linear-bug-ticket'),
  -- ['Vibe Code'] = require('plugins.ai.codecompanion.promptlibrary.vibe_code'),
  -- ['inline'] = require('plugins.ai.codecompanion.promptlibrary.inline'),
  -- ['Lua Developer'] = require('plugins.ai.codecompanion.promptlibrary.lua_developer'),
  -- ['Python Developer'] = require('plugins.ai.codecompanion.promptlibrary.python_dev'),
}

-- local beastMode = require('plugins.ai.codecompanion.promptlibrary.beastmode')
-- local cot = require('plugins.ai.codecompanion.promptlibrary.chain_of_thought')
-- local dailyPlanning = require('plugins.ai.codecompanion.promptlibrary.dailyPlanning')
-- local living_docs = require('plugins.ai.codecompanion.promptlibrary.living_docs')
local commit_pull_request = require('plugins.ai.codecompanion.promptlibrary.commit_pull_request')
local linearReleaseNote = require('plugins.ai.codecompanion.promptlibrary.linear_release_notes')
local others = require('plugins.ai.codecompanion.promptlibrary.others')
local pr_review_prompt = require('plugins.ai.codecompanion.promptlibrary.review_pull_request')
local retrieval = require('plugins.ai.codecompanion.promptlibrary.retrieval')
local review_documents = require('plugins.ai.codecompanion.promptlibrary.review_documentation')
local testgenerator = require('plugins.ai.codecompanion.promptlibrary.test_generator')
local vectorcode = require('plugins.ai.codecompanion.promptlibrary.vectorcode')

return vim.tbl_extend(
  'force',
  {},
  vectorcode,
  prompt_library,
  review_documents,
  -- fabric,
  -- dailyPlanning,
  -- beastMode,
  -- cot,
  commit_pull_request,
  others,
  retrieval,
  pr_review_prompt,
  testgenerator,
  linearReleaseNote
)
