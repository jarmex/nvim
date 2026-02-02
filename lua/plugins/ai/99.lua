return {
  {
    '4esv/99',
    event = 'VeryLazy',
    enabled = false,
    config = function()
      local _99 = require('99')

      -- For logging that is to a file if you wish to trace through requests
      -- for reporting bugs, i would not rely on this, but instead the provided
      -- logging mechanisms within 99.  This is for more debugging purposes
      local cwd = vim.uv.cwd()
      local basename = vim.fs.basename(cwd)
      _99.setup({
        logger = {
          level = _99.DEBUG,
          path = '/tmp/' .. basename .. '.99.debug',
          print_on_error = true,
        },

        -- model = 'anthropic/claude-sonnet-4-5',
        model = 'openrouter/qwen/qwen3-coder',

        --- A new feature that is centered around tags
        completion = {
          --- Defaults to .cursor/rules
          -- I am going to disable these until i understand the
          -- problem better.  Inside of cursor rules there is also
          -- application rules, which means i need to apply these
          -- differently
          -- cursor_rules = "<custom path to cursor rules>"

          --- A list of folders where you have your own SKILL.md
          --- Expected format:
          --- /path/to/dir/<skill_name>/SKILL.md
          ---
          --- Example:
          --- Input Path:
          --- "scratch/custom_rules/"
          ---
          --- Output Rules:
          --- {path = "scratch/custom_rules/vim/SKILL.md", name = "vim"},
          --- ... the other rules in that dir ...
          ---
          custom_rules = {
            'scratch/custom_rules/',
          },

          --- What autocomplete do you use.  We currently only
          --- support cmp right now
          source = 'cmp',
        },

        --- WARNING: if you change cwd then this is likely broken
        --- ill likely fix this in a later change
        ---
        --- md_files is a list of files to look for and auto add based on the location
        --- of the originating request.  That means if you are at /foo/bar/baz.lua
        --- the system will automagically look for:
        --- /foo/bar/AGENT.md
        --- /foo/AGENT.md
        --- assuming that /foo is project root (based on cwd)
        md_files = {
          'AGENT.md',
        },
      })
      -- from https://github.com/4esv/nvim-config/blob/main/lua/plugins/4-dev.lua
      -- Smart fill: detects visual vs normal mode
      local function smart_fill(with_prompt)
        return function()
          local mode = vim.fn.mode()
          if mode == 'v' or mode == 'V' or mode == '\22' then
            if with_prompt then
              _99.visual_prompt()
            else
              _99.visual()
            end
          else
            if with_prompt then
              _99.fill_in_function_prompt()
            else
              _99.fill_in_function()
            end
          end
        end
      end
      vim.keymap.set({ 'n', 'v' }, '<leader>9<CR>', smart_fill(true), { desc = '99: Fill (prompt)' })
      vim.keymap.set({ 'n', 'v' }, '<leader>9<leader>', smart_fill(false), { desc = '99: Fill (direct)' })
      -- Control
      vim.keymap.set('n', '<leader>9s', function()
        _99.stop_all_requests()
      end, { desc = '99: Stop all requests' })
      vim.keymap.set('n', '<leader>9i', function()
        _99.info()
      end, { desc = '99: Info' })
      -- Logs
      vim.keymap.set('n', '<leader>9l', function()
        _99.view_logs()
      end, { desc = '99: View logs' })
      vim.keymap.set('n', '<leader>9[', function()
        _99.prev_request_logs()
      end, { desc = '99: Prev request logs' })
      vim.keymap.set('n', '<leader>9]', function()
        _99.next_request_logs()
      end, { desc = '99: Next request logs' })
      vim.keymap.set('n', '<leader>9q', function()
        _99.previous_requests_to_qfix()
      end, { desc = '99: Requests to quickfix' })
      vim.keymap.set('n', '<leader>9c', function()
        _99.clear_previous_requests()
      end, { desc = '99: Clear request history' })

      -- Create your own short cuts for the different types of actions
      vim.keymap.set('n', '<leader>pf', function()
        _99.fill_in_function()
      end, { desc = 'Fill in function with 99' })
      -- take extra note that i have visual selection only in v mode
      -- technically whatever your last visual selection is, will be used
      -- so i have this set to visual mode so i dont screw up and use an
      -- old visual selection
      --
      -- likely ill add a mode check and assert on required visual mode
      -- so just prepare for it now
      vim.keymap.set('v', '<leader>pv', function()
        _99.visual_prompt()
      end, { desc = 'Visual prompt with 99' })

      --- if you have a request you dont want to make any changes, just cancel it
      vim.keymap.set('n', '<leader>ps', function()
        _99.stop_all_requests()
      end, { desc = 'Stop all 99 requests' })
    end,
  },
}
