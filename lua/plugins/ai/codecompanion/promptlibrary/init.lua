-- local promptList = require('plugins.ai.codecompanion.promptlibrary.awesome-prompts')

local fabric = require('plugins.ai.codecompanion.promptlibrary.fabric').load_fabric_patterns()

local function chat_filter(chat_data)
  -- TODO: check to remove this in future
  return vim.g.project_root == chat_data.project_root or vim.g.project_root == chat_data.cwd
end

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
  -- ['Agent Mode'] = require('plugins.ai.codecompanion.promptlibrary.agent_mode'),
  ['Bug Finder'] = require('plugins.ai.codecompanion.promptlibrary.bug_finder'),
  ['Code Expert'] = require('plugins.ai.codecompanion.promptlibrary.code_expert'),
  ['Code review'] = require('plugins.ai.codecompanion.promptlibrary.code_review'),
  ['Explain architecture'] = require('plugins.ai.codecompanion.promptlibrary.explain_architecture'),
  ['Explain code'] = require('plugins.ai.codecompanion.promptlibrary.explain_code'),
  ['Fix LSP Diagnostics'] = require('plugins.ai.codecompanion.promptlibrary.fix_lsp'),
  ['Generate Docstring'] = require('plugins.ai.codecompanion.promptlibrary.doc_string'),
  -- ['Generate a Commit Message for Staged Files'] = require('plugins.ai.codecompanion.promptlibrary.scommit'),
  -- ['Git Diff Code Review'] = require('plugins.ai.codecompanion.promptlibrary.git_diff_code_review'),
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
  ['Lua Developer'] = require('plugins.ai.codecompanion.promptlibrary.lua_developer'),
  ['Python Developer'] = require('plugins.ai.codecompanion.promptlibrary.python_dev'),
  ['Linear Feature Ticket'] = require('plugins.ai.codecompanion.promptlibrary.linear-feat-ticket'),
  ['Linear Bug Ticket'] = require('plugins.ai.codecompanion.promptlibrary.linear-bug-ticket'),
  ['Edit'] = {
    strategy = 'chat',
    description = 'Edit the current buffer',
    prompts = {
      { role = 'user', content = '@{insert_edit_into_file} #{buffer}\n\n' },
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
      { role = 'user', content = '@{full_stack_dev} #{buffer}\n\n' },
    },
    opts = {
      auto_submit = false,
      short_name = 'dev',
      is_slash_cmd = true,
    },
  },
  ['Saved Project Chats ...'] = {
    strategy = 'chat',
    description = 'Browse saved project chats',
    opts = {
      index = 4,
      stop_context_insertion = true,
    },
    condition = function()
      local history = require('codecompanion').extensions.history
      local have_chats = not vim.tbl_isempty(history.get_chats(chat_filter))
      local mode = vim.api.nvim_get_mode()
      return have_chats and (mode.mode == 'n' or mode.mode == 'i')
    end,
    prompts = {
      n = function()
        local history = require('codecompanion').extensions.history
        history.browse_chats(chat_filter)
      end,
      i = function()
        local history = require('codecompanion').extensions.history
        history.browse_chats(chat_filter)
      end,
    },
  },
  ['Saved Chats ...'] = {
    strategy = 'chat',
    description = 'Browse all saved chats',
    opts = {
      index = 5,
      stop_context_insertion = true,
    },
    condition = function()
      local history = require('codecompanion').extensions.history
      local have_chats = not vim.tbl_isempty(history.get_chats())
      local mode = vim.api.nvim_get_mode()
      return have_chats and (mode.mode == 'n' or mode.mode == 'i')
    end,
    prompts = {
      n = function()
        local history = require('codecompanion').extensions.history
        history.browse_chats()
      end,
      i = function()
        local history = require('codecompanion').extensions.history
        history.browse_chats()
      end,
    },
  },
  ['Agent'] = {
    strategy = 'chat',
    description = 'Create a new chat buffer in Agent mode',
    opts = {
      index = 6,
      stop_context_insertion = true,
      adapter = {
        name = 'anthropic',
        model = 'claude-sonnet-4', -- Multiplier = 1.
      },
    },
    prompts = {
      {
        role = 'user',
        content = '#{mcp:neovim://workspace} @{agent} ',
      },
    },
  },
  ['Free Agent (GPT-4o)'] = {
    strategy = 'chat',
    description = 'Create a new chat buffer in Agent mode with GPT-4o',
    opts = {
      index = 7,
      stop_context_insertion = true,
      adapter = {
        name = 'openai',
        model = 'gpt-4o', -- Multiplier = 0 (free).
      },
    },
    prompts = {
      {
        role = 'user',
        content = '#{mcp:neovim://workspace} @{agent} ',
      },
    },
  },
}

local living_docs = require('plugins.ai.codecompanion.promptlibrary.living_docs')
prompt_library = vim.tbl_extend('force', prompt_library, living_docs)

local review_documents = require('plugins.ai.codecompanion.promptlibrary.review_documentation')
prompt_library = vim.tbl_extend('force', prompt_library, review_documents)

local dailyPlanning = require('plugins.ai.codecompanion.promptlibrary.dailyPlanning')
prompt_library = vim.tbl_extend('force', prompt_library, dailyPlanning)

local commit_pull_request = require('plugins.ai.codecompanion.promptlibrary.commit_pull_request')
prompt_library = vim.tbl_extend('force', prompt_library, commit_pull_request)

-- return vim.tbl_extend('force', promptList.prompt_library(), {
return vim.tbl_extend('force', {}, fabric, prompt_library)
