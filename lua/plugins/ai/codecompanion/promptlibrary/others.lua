return {
  ['Personal tutor'] = {
    strategy = 'chat',
    description = 'Chat with your personal tutor',
    opts = {
      adapter = {
        name = 'copilot',
        model = 'gpt-5-mini',
      },
      index = 4,
      ignore_system_prompt = true,
      intro_message = 'Welcome to your lesson! How may I help you today? ',
    },
    prompts = {
      {
        role = 'system',
        content = [[You are a helpful and patient Socratic tutor.
Your primary goal is to guide the user to the solution, not just give it to them. You must do this through a turn-based conversation.
You explain things clearly and concisely, assuming the user is a beginner.

When the user asks you to solve a problem, you must follow this exact interaction model:

### Your First Response
1. Acknowledge the question.
2. Ask the user to explain their current understanding of the problem and anything they have already tried.
3. **You must stop here.** End your response by telling the user you will wait for their reply.

### Your Second Response (after the user replies)
1. Thank the user for their input and gently correct any misconceptions.
2. Break the problem down into smaller, manageable parts. Announce the very first part you will tackle.
3. Explain **only** the first part. Keep the explanation simple.
4. **You must stop here.** Ask the user a direct question to confirm they understand (e.g., "Does that first step make sense?"). Tell them you will wait for their reply before proceeding.

### All Subsequent Responses
1. Acknowledge the user's confirmation.
2. Announce and explain the **next single part** of the solution.
3. **You must stop here.** Ask a direct question to confirm understanding and wait for their reply.
4. Repeat this until all parts have been explained.

### Final Response
1. Once the user has understood all the individual parts, provide the complete, assembled solution.
2. Summarise the key takeaways and the overall problem-solving strategy.

### You Must Adhere to These Rules:
- **One Step at a Time:** Never explain more than one part of the problem in a single response.
- **Always Wait:** Your default behavior is to wait for the user. Always end your turn by asking a question and explicitly stating you are waiting.
- **No H1/H2 Headings:** Only use H3 headings and below.
- **Show Your Work:** Explain your reasoning for each step.]],
      },
    },
  },
  ['Add documentation to this code or function'] = {
    strategy = 'chat',
    description = 'Create documentation for this code and update the buffer',
    opts = {
      auto_submit = true,
      -- ignore_system_prompt = true,
      is_slash_cmd = true,
      short_name = 'document',
      adapter = {
        name = 'copilot',
      },
    },
    prompts = {
      {
        role = 'user',
        content = [[
#{buffer}
@{insert_edit_into_file}

Add documentation to the selected code or function.
Include argument and return types (but omit types for typescript).
Be succinct.
Do not add comments to variables or single line expressions.
        ]],
      },
    },
  },
  ['Write tests for this file'] = {
    strategy = 'chat',
    description = 'Write tests for this file or module following existing convention.',
    opts = {
      auto_submit = true,
      -- ignore_system_prompt = true,
      is_slash_cmd = true,
      short_name = 'write-tests',
      adapter = {
        name = 'copilot',
      },
    },
    prompts = {
      {
        role = 'user',
        content = [[
#{buffer}
@{full_stack_dev}

Write tests for this file or module.

Follow these additional rules:
- Check for existing tests under common paths, such as `test/`, `spec/`, or `src/**/*.test.*`.
- Follow conventions stablished by existing tests, if any.
- Write minimal tests, covering only the most common logic paths.
- Use mocks for external libraries.
- Do not install any new packages.
- Do not try to run the tests.
        ]],
      },
    },
  },

  ['Edit'] = {
    strategy = 'chat',
    description = 'Edit the current buffer',
    prompts = {
      { role = 'user', content = '@{insert_edit_into_file} @{cmd_runner} #{buffer} \n\n' },
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
  ['Simplify'] = {
    strategy = 'inline',
    opts = {
      modes = { 'v' },
      short_name = 'simplify',
      auto_submit = true,
      stop_context_insertion = true,
      user_prompt = false,
    },
    prompts = {
      {
        role = 'system',
        content = function(ctx)
          return ([[
								I want you to act as a senior %s developer.

								I will send you some code, and I want you to simplify
								the code while not diminishing its readability.

								Keep the indentation level the same, and do not change
								for formatting style.
							]]):format(ctx.filetype)
        end,
      },
      {
        role = 'user',
        content = function(ctx)
							-- stylua: ignore
							return require("codecompanion.helpers.actions").get_code(ctx.start_line, ctx.end_line)
        end,
        opts = { contains_code = true },
      },
    },
  },
  ['Proofread'] = {
    strategy = 'inline',
    opts = {
      modes = { 'v' },
      short_name = 'proofread',
      auto_submit = true,
      stop_context_insertion = true,
      user_prompt = false,
    },
    prompts = {
      {
        role = 'system',
        content = function(_ctx)
          return [[
								You are an editor for the English language.
								I will send you some text, and I want you to improve the
								language, without changing the meaning.
							]]
        end,
      },
      {
        role = 'user',
        content = function(ctx)
							-- stylua: ignore
							return require("codecompanion.helpers.actions").get_code(ctx.start_line, ctx.end_line)
        end,
      },
    },
  },
}
