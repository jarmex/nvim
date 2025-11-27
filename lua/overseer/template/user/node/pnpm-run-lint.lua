return {
  name = 'pnpm-run-lint',
  builder = function()
    return {
      cmd = 'pnpm',
      args = { 'run', 'lint' },
      cwd = vim.fn.getcwd(),
      name = 'pnpm-run-lint',
      components = {
        { 'on_complete_notify', on_change = true },
        'on_result_diagnostics',
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
