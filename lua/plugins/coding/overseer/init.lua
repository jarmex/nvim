local run_last_task = function()
  local overseer = require('overseer')
  local tasks = overseer.list_tasks({ recent_first = true })
  if vim.tbl_isempty(tasks) then
    vim.notify('No tasks found', vim.log.levels.WARN)
  else
    overseer.run_action(tasks[1], 'restart')
  end
end

local function open_first_failed_task()
  local overseer = require('overseer')
  local constants = require('overseer.constants')
  local action_util = require('overseer.action_util')
  local failed_tasks = overseer.list_tasks({ status = constants.STATUS.FAILURE })
  if #failed_tasks > 0 then
    local task = failed_tasks[1] ---@type overseer.Task
    action_util.run_task_action(task, 'open hsplit')
  else
    vim.notify('No failed tasks found', vim.log.levels.WARN, { title = 'Overseer' })
  end
end
return {
  --  overseer [task runner]
  --  https://github.com/stevearc/overseer.nvim
  {
    'stevearc/overseer.nvim',
    -- tag = 'v1.6.0',
    cmd = {
      'OverseerClose',
      'OverseerFromTerminal',
      'OverseerInfo',
      'OverseerOpen',
      'OverseerRun',
      'OverseerTaskAction',
      'OverseerToggle',
    },
    keys = {
      { '<leader>o', '', desc = 'Overseer' },
      { '<leader>ol', '<cmd>OverseerTaskAction<cr>', desc = 'Task Action' },
      { '<leader>oc', '<cmd>OverseerClose<cr>', desc = 'Close' },
      { '<leader>oo', run_last_task, desc = 'Run the last Overseer task' },
      { '<leader>or', '<cmd>OverseerRun<cr>', desc = 'Run' },
      { '<leader>ot', '<cmd>OverseerToggle<cr>', desc = 'Toggle' },
      { '<leader>ox', '<cmd>OverseerFromTerminal<cr>', mode = { 'n', 'v' }, desc = 'Overseer From Terminal' },
      { '<leader>oa', '<cmd>OverseerRestartLast<cr>', desc = 'Overseer Restart Last' },
      { '<leader>op', open_first_failed_task, desc = 'Overseer Open Failed Task' },
      {
        '<leader>od',
        function()
          local overseer = require('overseer')
          local task_list = require('overseer.task_list')
          local tasks = overseer.list_tasks({
            sort = task_list.sort_finished_recently,
            include_ephemeral = true,
          })
          if vim.tbl_isempty(tasks) then
            vim.notify('No tasks found', vim.log.levels.WARN)
          else
            local most_recent = tasks[1]
            overseer.run_action(most_recent)
          end
        end,
        mode = 'n',
        desc = '[O]verseer [D]o quick action',
      },
    },
    opts = {
      dap = false,
      output = {
        -- Use a terminal buffer to display output. If false, a normal buffer is used
        use_terminal = true,
        -- If true, don't clear the buffer when a task restarts
        preserve_output = false,
      },
      templates = { 'builtin', 'user' },
      -- Auto-detect task files
      auto_detect_success_color = true,
      strategy = { 'jobstart', preserve_output = true, use_terminal = true, use_shell = true },
      task_launcher = {
        bindings = {
          n = {
            ['<leader>c'] = 'Cancel',
          },
        },
      },
      task_list = {
        default_detail = 2,
        direction = 'bottom',
        min_height = 17,
        max_height = 17,
        min_width = 0.4,
        max_width = 0.4,
        separator = '',
        bindings = {
          ---@diagnostic disable-next-line: assign-type-mismatch
          ['<C-s>'] = false,
          ['<C-h>'] = false,
          ['<C-j>'] = false,
          ['<C-k>'] = false,
          ['<C-l>'] = false,
          ['<C-x>'] = 'OpenSplit',
          ['zo'] = 'IncreaseDetail',
          ['zc'] = 'DecreaseDetail',
          ['zr'] = 'IncreaseDetail',
          ['zm'] = 'DecreaseDetail',
          [']'] = false,
          ['['] = false,
          ['[t'] = 'PrevTask',
          [']t'] = 'NextTask',
          ['<C-r>'] = '<CMD>OverseerQuickAction restart<CR>',
          ['<C-d>'] = '<CMD>OverseerQuickAction dispose<CR>',
          ['<A-v>'] = 'TogglePreview',
          ['<A-j>'] = 'ScrollOutputDown',
          ['<A-k>'] = 'ScrollOutputUp',
          ['dd'] = 'Dispose',
          ['ss'] = 'Stop',
        },
        -- default_detail = 1,
      },
      form = {
        border = vim.g.borderStyle,
        win_opts = {
          winblend = 0,
          winhl = 'FloatBorder:NormalFloat',
        },
      },
      confirm = {
        win_opts = {
          winblend = 0,
        },
      },
      task_win = {
        win_opts = {
          winblend = 0,
        },
      },
      component_aliases = {
        default = {
          'user.interactive_shell', -- run tasks in interactive shell so aliases/functions are available
          'user.on_output_parse', -- parse with problem matcher
          'on_exit_set_status', -- set the status based on exit code
          { 'on_complete_notify', system = 'unfocused' }, -- popup notification
          { 'on_result_diagnostics', remove_on_restart = true, underline = true }, -- display diagnostics
          { 'on_complete_dispose', require_view = { 'SUCCESS', 'FAILURE' } },
          'unique',
          { 'user.on_complete_close_term', statuses = { 'SUCCESS' }, timeout = 5 },
        },
        default_neotest = {
          'unique',
          'on_exit_set_status',
          'on_complete_dispose',
        },
      },
    },
    config = function(_, opts)
      local overseer = require('overseer')
      local util = require('overseer.util')

      local otherCommands = require('plugins.coding.overseer.commands')

      -- Override run_in_cwd to prevent fullscreen terminal execution and output flickering
      ---@diagnostic disable-next-line: duplicate-set-field
      util.run_in_cwd = function(cwd, callback)
        vim.cmd.lcd({ args = { cwd }, mods = { silent = true, noautocmd = true } })
        callback()
      end

      overseer.setup(opts)

      otherCommands.setup(overseer)
    end,
  },
}
