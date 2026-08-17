return {
  ['CLI: Custom Prompt'] = {
    interaction = 'chat',
    description = 'Open input buffer and write a prompt for the CLI agent',
    opts = { index = 20 },
    prompts = {
      n = function()
        require('codecompanion').cli({ prompt = true })
      end,
      v = function()
        require('codecompanion').cli({ prompt = true })
      end,
    },
  },
  ['CLI: Share Buffer'] = {
    interaction = 'chat',
    description = 'Share current buffer (or selection) with the CLI agent',
    opts = { index = 21 },
    prompts = {
      n = function()
        require('codecompanion').cli('#{buffer}', { focus = false })
      end,
      v = function()
        vim.cmd('normal! gv')
        require('codecompanion').cli('#{this}', { focus = false })
      end,
    },
  },
  ['CLI: Share Diagnostics'] = {
    interaction = 'chat',
    description = 'Share diagnostics from current buffer with the CLI agent',
    opts = { index = 22 },
    prompts = {
      n = function()
        require('codecompanion').cli('#{diagnostics}', { focus = false })
      end,
      v = function()
        require('codecompanion').cli('#{diagnostics}', { focus = false })
      end,
    },
  },
  ['CLI: Fix Diagnostics'] = {
    interaction = 'chat',
    description = 'Send diagnostics to the CLI agent and ask for a fix',
    opts = { index = 23 },
    prompts = {
      n = function()
        require('codecompanion').cli('#{diagnostics} Fix these diagnostics.', { focus = false, submit = true })
      end,
      v = function()
        require('codecompanion').cli('#{diagnostics} Fix these diagnostics.', { focus = false, submit = true })
      end,
    },
  },
  ['CLI: Share Terminal Output'] = {
    interaction = 'chat',
    description = 'Share latest terminal output with the CLI agent',
    opts = { index = 24 },
    prompts = {
      n = function()
        require('codecompanion').cli('#{terminal}', { focus = false })
      end,
      v = function()
        require('codecompanion').cli('#{terminal}', { focus = false })
      end,
    },
  },
  ['CLI: Fix Terminal Errors'] = {
    interaction = 'chat',
    description = 'Send terminal output to the CLI agent and ask for a fix',
    opts = { index = 25 },
    prompts = {
      n = function()
        require('codecompanion').cli(
          '#{terminal} This is the latest terminal output. Investigate and fix the errors.',
          { focus = false, submit = true }
        )
      end,
      v = function()
        require('codecompanion').cli(
          '#{terminal} This is the latest terminal output. Investigate and fix the errors.',
          { focus = false, submit = true }
        )
      end,
    },
  },
  ['CLI: Explain Code'] = {
    interaction = 'chat',
    description = 'Ask the CLI agent to explain buffer or selection',
    opts = { index = 26 },
    prompts = {
      n = function()
        require('codecompanion').cli('#{buffer} Explain this code.', { submit = true })
      end,
      v = function()
        vim.cmd('normal! gv')
        require('codecompanion').cli('#{this} Explain this code.', { submit = true })
      end,
    },
  },
  ['CLI: Review Buffer'] = {
    interaction = 'chat',
    description = 'Ask the CLI agent to review buffer or selection',
    opts = { index = 28 },
    prompts = {
      n = function()
        require('codecompanion').cli(
          '#{buffer} Review this code. Point out bugs, code smells, and possible simplifications. One line per finding: location, problem, suggested fix.',
          { submit = true }
        )
      end,
      v = function()
        vim.cmd('normal! gv')
        require('codecompanion').cli(
          '#{this} Review this code. Point out bugs, code smells, and possible simplifications. One line per finding: location, problem, suggested fix.',
          { submit = true }
        )
      end,
    },
  },
  ['CLI: Share Quickfix List'] = {
    interaction = 'chat',
    description = 'Share quickfix list items with the CLI agent',
    opts = { index = 29 },
    prompts = {
      n = function()
        require('codecompanion').cli('#{quickfix}', { focus = false })
      end,
      v = function()
        require('codecompanion').cli('#{quickfix}', { focus = false })
      end,
    },
  },
  ['CLI: Bump Dependencies'] = {
    interaction = 'chat',
    description = 'Ask the CLI agent to update project dependencies to latest versions',
    opts = { index = 30 },
    prompts = {
      n = function()
        require('codecompanion').cli(
          'Detect the package manager and dependency manifest used by this project. Update all dependencies to their latest compatible versions, then build or load the project to verify nothing breaks. Report what was bumped and any breaking changes you had to handle.',
          { submit = true }
        )
      end,
      v = function()
        require('codecompanion').cli(
          'Detect the package manager and dependency manifest used by this project. Update all dependencies to their latest compatible versions, then build or load the project to verify nothing breaks. Report what was bumped and any breaking changes you had to handle.',
          { submit = true }
        )
      end,
    },
  },
  ['CLI: Run App & Fix Errors'] = {
    interaction = 'chat',
    description = 'Ask the CLI agent to run the app and fix any errors',
    opts = { index = 31 },
    prompts = {
      n = function()
        require('codecompanion').cli(
          'Figure out how this project is run (check README, scripts, build files). Run the app, capture any startup or runtime errors, fix them, and rerun until it starts cleanly. Report each error found and how you fixed it.',
          { submit = true }
        )
      end,
      v = function()
        require('codecompanion').cli(
          'Figure out how this project is run (check README, scripts, build files). Run the app, capture any startup or runtime errors, fix them, and rerun until it starts cleanly. Report each error found and how you fixed it.',
          { submit = true }
        )
      end,
    },
  },
  ['CLI: Run Tests & Fix Failures'] = {
    interaction = 'chat',
    description = 'Ask the CLI agent to run the test suite and fix failing cases',
    opts = { index = 32 },
    prompts = {
      n = function()
        require('codecompanion').cli(
          'Detect the test framework and runner for this project. Run the full test suite, then fix the failing tests one by one - prefer fixing the code under test unless the test itself is clearly wrong. Rerun until green. Report each failure and its fix.',
          { submit = true }
        )
      end,
      v = function()
        require('codecompanion').cli(
          'Detect the test framework and runner for this project. Run the full test suite, then fix the failing tests one by one - prefer fixing the code under test unless the test itself is clearly wrong. Rerun until green. Report each failure and its fix.',
          { submit = true }
        )
      end,
    },
  },
  ['CLI: Share All Buffers'] = {
    interaction = 'chat',
    description = 'Share all open buffers with the CLI agent',
    opts = { index = 27 },
    prompts = {
      n = function()
        require('codecompanion').cli('#{buffers}', { focus = false })
      end,
      v = function()
        require('codecompanion').cli('#{buffers}', { focus = false })
      end,
    },
  },
}
