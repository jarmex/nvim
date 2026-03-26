return {
  name = 'pnpm-run-lint',
  builder = function()
    local util = require('overseer.component.user.util')
    return {
      cmd = 'pnpm',
      args = { 'run', 'lint' },
      cwd = vim.fn.getcwd(),
      name = 'pnpm-run-lint',
      components = {
        { 'on_output_parse', problem_matcher = util.biome_problem_matcher },
        'on_result_diagnostics',
        { 'on_result_diagnostics_quickfix', open = true },
        { 'on_complete_notify', on_change = true },
        'default',
      },
    }
  end,
  desc = 'Run Package Manager (pnpm run lint)',
  condition = {
    callback = function()
      return vim.fn.filereadable('package.json') == 1
    end,
  },
}
