return {
  'mfussenegger/nvim-lint',
  event = { 'BufWritePost', 'BufReadPost', 'InsertLeave' },
  keys = {
    {
      '<leader>cin',
      function()
        vim.notify(vim.inspect(require('lint').linters[vim.bo.filetype]))
      end,
      silent = true,
      desc = 'Linter Info',
    },
  },
  opts = {
    linters = {
      markdownlint = {
        args = { '--config', '~/.config/nvim/.linter_configs/markdownlint.json', '--' },
      },
    },
    linters_by_ft = {
      -- python = { "ruff" },
      dockerfile = { 'hadolint' },
      htmldjango = { 'djlint' },
      -- lua = { 'selene' },
      sh = { 'shellcheck' },
      markdown = { 'markdownlint' },
      ['css'] = { 'stylelint' },
      ['scss'] = { 'stylelint' },
      ['less'] = { 'stylelint' },
      sql = { 'sqlfluff' },
      yaml = { 'yamllint' },
    },
  },
  config = function(_, opts)
    local lint = require('lint')
    lint.linters_by_ft = opts.linters_by_ft
    lint.linters = opts.linters

    vim.keymap.set('n', '<leader>lt', function()
      lint.try_lint()
    end, { desc = 'lint file' })

    vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufWritePost', 'BufReadPost' }, {
      group = vim.api.nvim_create_augroup('lint', { clear = true }),
      callback = function()
        local lint_status, nvim_lint = pcall(require, 'lint')
        if lint_status then
          nvim_lint.try_lint()
        end
      end,
    })
  end,
}
