return {
  ['Personal tutor'] = {
    interaction = 'chat',
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
    interaction = 'chat',
    description = 'Create documentation for this code and update the buffer',
    opts = {
      auto_submit = true,
      -- ignore_system_prompt = true,
      is_slash_cmd = true,
      alias = 'document',
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

  ['Edit Current Buffer'] = {
    interaction = 'chat',
    description = 'Edit the current buffer',
    prompts = {
      {
        role = 'system',
        content = [[You are an experienced developer. You will be requested to make some changes to a provided buffer. Keep
your responses concise and to the point. Don't include next-step suggestions. When the user asks you a question about
the buffer, edit it with your suggestions using your editor tool unless the user asks you to do otherwise.]],
      },
      {
        role = 'user',
        -- content = '@{insert_edit_into_file} @{cmd_runner} #{buffer} \n\n'
        content = 'Here is the current buffer: #{buffer}\n\nUsing your @{insert_edit_into_file} and @{cmd_runner} tool, make the following change(s):\n\n',
      },
    },
    opts = {
      auto_submit = false,
      alias = 'edit',
      is_slash_cmd = true,
    },
  },
  ['Develop'] = {
    interaction = 'chat',
    description = 'Edit with full tooling',
    prompts = {
      { role = 'user', content = '@{full_stack_dev} #{buffer}\n\n' },
    },
    opts = {
      auto_submit = false,
      alias = 'dev',
      is_slash_cmd = true,
    },
  },
  ['Saved Chats ...'] = {
    interaction = 'chat',
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
    interaction = 'chat',
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
    interaction = 'chat',
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
