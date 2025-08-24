return {
  name = 'pnpm-run-dev',
  builder = function()
    return {
      cmd = 'pnpm',
      args = { 'run', 'dev' },
      cwd = vim.fn.getcwd(),
      name = 'pnpm-run-dev',
      components = {
        { 'on_complete_notify', on_change = true },
        'on_result_diagnostics',
        'default',
      },
    }
  end,
  desc = 'Run Package Manager (pnpm run dev)',
  condition = {
    callback = function()
      return vim.fn.filereadable('package.json') == 1
    end,
  },
}
