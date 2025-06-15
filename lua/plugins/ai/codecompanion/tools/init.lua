return {
  -- ['code_crawler'] = require('plugins.ai.codecompanion.tools.code_crawler'),
  -- ['code_edit'] = require('plugins.ai.codecompanion.tools.code_edit'),
  -- ['tavily'] = require('plugins.ai.codecompanion.tools.tavily'),
  -- ['code_developer'] = require('plugins.ai.codecompanion.tools.developer'),

  opts = {
    -- system_prompt = string.format([[]]),
    auto_submit_errors = true, -- Send any errors to the LLM automatically
    auto_submit_success = false, -- Send any successful output to the LLM automatically
    wait_timeout = 300000,
  },
  plan = {
    callback = require('plugins.ai.codecompanion.tools.plan'),
    description = 'Manage an internal todo list',
  },
}
